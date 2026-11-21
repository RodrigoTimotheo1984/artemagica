import subprocess, os, sys
from PIL import Image, ImageDraw, ImageFont, ImageFilter
S=sys.argv[1]; SRC=f"{S}/src/materia.bin"; O=f"{S}/build"; os.makedirs(O,exist_ok=True)
W,H=1080,1920; VY=470; VH=608
F="/usr/share/fonts/opentype/inter/Inter-"
def font(w,s): return ImageFont.truetype(F+w+".otf",s)
BG=(0,0,0); AMB=(255,200,61); WH=(255,255,255); GR=(170,170,176); RED=(226,58,58)

def bg():
    im=Image.new("RGB",(W,H),BG); d=ImageDraw.Draw(im)
    for y in range(H):
        t=y/H; d.line([(0,y),(W,y)],fill=(int(10*t),int(10*t),int(12*t)))
    return im
def center(d,y,txt,f,fill,sp=0):
    w=d.textlength(txt,font=f); d.text(((W-w)/2,y),txt,font=f,fill=fill); return y+f.size+sp
def wrap(d,txt,f,maxw):
    out=[];cur=""
    for w in txt.split():
        t=(cur+" "+w).strip()
        if d.textlength(t,font=f)<=maxw: cur=t
        else: out.append(cur);cur=w
    out.append(cur); return out

def card(name,lines,dur,small=None,img=None,fadein=True):
    im=bg(); d=ImageDraw.Draw(im)
    tot=sum(sz*1.18 for _,_,sz in lines)
    if img:
        ph=Image.open(img).convert("RGB"); ph=Image.eval(ph,lambda v:int(v*0.82))
        im.paste(ph,(0,110))
        g=Image.new("L",(W,360),0); gd=ImageDraw.Draw(g)
        for yy in range(360): gd.line([(0,yy),(W,yy)],fill=int(255*yy/359))
        im.paste(Image.new("RGB",(W,360),(0,0,0)),(0,110+938-360),g)
        d=ImageDraw.Draw(im); y=1180
    else:
        y=(H-tot)/2-40
    d.rectangle([W/2-60,y-70,W/2+60,y-62],fill=RED)
    for t,c,sz in lines:
        center(d,y,t,font("Black",sz),c); y+=sz*1.18
    if small: center(d,y+50,small,font("Medium",38),GR)
    p=f"{O}/{name}.png"; im.save(p)
    out=f"{O}/{name}.mp4"
    fi="fade=in:st=0:d=0.35," if fadein else ""
    subprocess.run(["ffmpeg","-v","error","-y","-loop","1","-t",str(dur),"-i",p,"-f","lavfi","-t",str(dur),"-i","anullsrc=r=48000:cl=stereo",
      "-vf",f"zoompan=z='1+0.03*on/({dur}*30)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s={W}x{H}:fps=30,{fi}fade=out:st={dur-0.25}:d=0.25,format=yuv420p",
      "-c:v","libx264","-preset","medium","-crf","18","-r","30","-c:a","aac","-b:a","160k","-ar","48000","-shortest",out],check=True)
    return out

def clip(name,a,b,label,caps):
    dur=b-a
    base=bg(); d=ImageDraw.Draw(base)
    d.rectangle([W/2-60,250,W/2+60,258],fill=RED)
    center(d,290,"A HISTÓRIA QUE",font("Black",54),WH); center(d,354,"NINGUÉM CONTOU",font("Black",54),AMB)
    d.rectangle([0,VY-6,W,VY+VH+6],fill=(255,255,255))
    # label
    lf=font("SemiBold",34); lw=d.textlength(label,font=lf)
    d.rounded_rectangle([40,VY+VH+40,40+lw+48,VY+VH+40+64],16,fill=(34,34,38)); d.text((64,VY+VH+52),label,font=lf,fill=AMB)
    center(d,H-120,"Trechos: programa “A Notícia de Frente”",font("Medium",30),GR)
    base.save(f"{O}/{name}_bg.png")
    ins=["-loop","1","-t",str(dur),"-i",f"{O}/{name}_bg.png","-ss",str(a),"-t",str(dur),"-i",SRC]
    fc=[f"[1:v]scale={W}:{VH}:flags=lanczos,unsharp=5:5:0.6,eq=contrast=1.04:saturation=1.05,fps=30[v];[0:v]fps=30[b];[b][v]overlay=0:{VY}[o0]"]
    cf=font("ExtraBold",66)
    for i,(s,e,t) in enumerate(caps):
        im=Image.new("RGBA",(W,H),(0,0,0,0)); dd=ImageDraw.Draw(im)
        ls=wrap(dd,t,cf,W-120); y=1250
        for l in ls:
            y=center(dd,y,l,cf,WH,sp=16)
        p=f"{O}/{name}_c{i}.png"; im.save(p); ins+=["-loop","1","-t",str(dur),"-i",p]
        fc.append(f"[o{i}][{i+2}:v]overlay=0:0:enable='between(t,{s-a:.2f},{e-a:.2f})'[o{i+1}]")
    n=len(caps)
    fc.append(f"[o{n}]fade=in:st=0:d=0.25,fade=out:st={dur-0.25:.2f}:d=0.25,format=yuv420p[vo]")
    fc.append(f"[1:a]highpass=f=90,acompressor=threshold=-20dB:ratio=3:makeup=4,loudnorm=I=-15:TP=-1.5:LRA=9,aresample=48000,afade=in:st=0:d=0.08,afade=out:st={dur-0.12:.2f}:d=0.12[ao]")
    out=f"{O}/{name}.mp4"
    subprocess.run(["ffmpeg","-v","error","-y",*ins,"-filter_complex",";".join(fc),"-map","[vo]","-map","[ao]","-t",str(dur),
      "-c:v","libx264","-preset","medium","-crf","18","-r","30","-c:a","aac","-b:a","160k","-ar","48000","-ac","2",out],check=True)
    return out

MED="Médica do Pronto-Socorro de Várzea Grande"; COM="Comentarista · A Notícia de Frente"
seq=[
 card("k1",[("Lembra do caso",WH,88),("da menina de 5 anos",WH,88),("no Pronto-Socorro?",WH,88)],3.2,fadein=False),
 card("k2",[("Tem uma parte",WH,100),("que não te",WH,100),("mostraram.",AMB,100)],3.2),
 clip("a",78.50,98.98,MED,[(78.5,81.05,"Nesse período, a criança foi avaliada"),(81.05,85.7,"por duas médicas neurologistas pediátricas distintas"),(85.7,88.55,"e por um membro da equipe de neurocirurgia."),(88.55,92.0,"Ela realizou tomografia computadorizada,"),(92.0,94.6,"ressonância magnética de crânio"),(94.6,98.98,"e foi avaliada e monitorizada clinicamente 24 horas por dia.")]),
 clip("b",193.70,205.65,MED,[(193.7,197.5,"Ela chegou às 23 horas do dia 13."),(197.5,202.15,"Antes do amanhecer, da troca de plantão do dia 14 de manhã,"),(202.15,205.65,"ela já tinha os exames que descartavam qualquer emergência.")]),
 clip("d",370.90,379.25,COM,[(370.9,376.85,"Ninguém vem a público para se posicionar dessa forma mentindo."),(376.85,379.25,"Tenho certeza que ela está falando a verdade.")]),
 clip("f1",388.30,395.75,COM,[(388.3,391.5,"É surpreendente, inclusive,"),(391.5,395.75,"que a Prefeitura mantém uma equipe neurológica permanentemente.")]),
 clip("f2",400.85,409.70,COM,[(400.85,405.0,"Não é qualquer lugar que tem neurologia."),(405.0,409.7,"É uma especialidade que tem muita dificuldade de ter profissionais.")]),
 clip("f3",412.05,419.95,COM,[(412.05,414.15,"Parabéns ao Pronto-Socorro."),(414.15,419.95,"Espero que, daqui pra frente, essa polêmica se encerre com a verdade.")]),
 card("k7",[("A criança recebeu",WH,84),("todo o atendimento.",WH,84),("Agora você conhece",AMB,84),("a história inteira.",AMB,84)],5.0,"Respeito à família. Respeito a quem cuida."),
]
open(f"{O}/list.txt","w").write("".join(f"file '{p}'\n" for p in seq))
subprocess.run(["ffmpeg","-v","error","-y","-f","concat","-safe","0","-i",f"{O}/list.txt","-c","copy",f"{O}/cut.mp4"],check=True)
dur=float(subprocess.check_output(["ffprobe","-v","error","-show_entries","format=duration","-of","csv=p=0",f"{O}/cut.mp4"]))
# trilha: pad grave e sóbrio, com ducking sob as falas
pad=("sine=f=110:r=48000[a1];sine=f=164.81:r=48000[a2];sine=f=220:r=48000[a3];sine=f=261.63:r=48000[a4];sine=f=55:r=48000[a5];"
     "[a1][a2][a3][a4][a5]amix=inputs=5:normalize=0:weights='0.5 0.35 0.3 0.22 0.5',tremolo=f=0.15:d=0.5,lowpass=f=900,aecho=0.8:0.7:120|260:0.4|0.3,volume=0.5,"
     f"afade=in:st=0:d=0.3,afade=out:st={dur-2.5:.2f}:d=2.5,aformat=channel_layouts=stereo[m];"
     f"aevalsrc='0.9*sin(2*PI*58*t)*exp(-7*t)+0.25*sin(2*PI*116*t)*exp(-12*t)':d=1.2:s=48000,aformat=channel_layouts=stereo,asplit=3[h1][h2][h3];[h2]adelay=3200:all=1[h2d];[h3]adelay={int((dur-5.0)*1000)}:all=1[h3d];[h1][h2d][h3d]amix=inputs=3:normalize=0:duration=longest[hit];"
     "[0:a]asplit[s1][s2];[m][s1]sidechaincompress=threshold=0.02:ratio=12:attack=40:release=600[md];[s2][md][hit]amix=inputs=3:normalize=0:duration=first,alimiter=limit=0.95[ao]")
subprocess.run(["ffmpeg","-v","error","-y","-i",f"{O}/cut.mp4","-filter_complex",pad,"-map","0:v","-map","[ao]","-c:v","copy","-c:a","aac","-b:a","160k","-movflags","+faststart","-t",f"{dur:.2f}",sys.argv[2]],check=True)
print("ok",dur)
