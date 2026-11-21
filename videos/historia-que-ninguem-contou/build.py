import subprocess, os, sys
from PIL import Image, ImageDraw, ImageFont, ImageFilter
S=sys.argv[1]; SRC=f"{S}/src/materia.bin"; O=f"{S}/build"; os.makedirs(O,exist_ok=True)
W,H=1080,1920; VY=470; VH=608
F="/usr/share/fonts/opentype/inter/Inter-"
def font(w,s): return ImageFont.truetype(F+w+".otf",s)
BG=(9,14,26); AMB=(255,200,61); WH=(255,255,255); GR=(160,172,196); RED=(226,58,58)

def bg():
    im=Image.new("RGB",(W,H),BG); d=ImageDraw.Draw(im)
    for y in range(H):
        t=y/H; d.line([(0,y),(W,y)],fill=(int(9+10*t),int(14+14*t),int(26+30*t)))
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

def card(name,lines,dur,small=None):
    # lines: list of (text, color, size)
    im=bg(); d=ImageDraw.Draw(im)
    tot=sum(s*1.18 for _,_,s in lines); y=(H-tot)/2-40
    d.rectangle([W/2-60,y-70,W/2+60,y-62],fill=RED)
    for t,c,s in lines:
        center(d,y,t,font("Black",s),c); y+=s*1.18
    if small: center(d,y+50,small,font("Medium",38),GR)
    p=f"{O}/{name}.png"; im.save(p)
    out=f"{O}/{name}.mp4"
    subprocess.run(["ffmpeg","-v","error","-y","-loop","1","-t",str(dur),"-i",p,"-f","lavfi","-t",str(dur),"-i","anullsrc=r=48000:cl=stereo",
      "-vf",f"zoompan=z='1+0.03*on/({dur}*30)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s={W}x{H}:fps=30,fade=in:st=0:d=0.35,fade=out:st={dur-0.35}:d=0.35,format=yuv420p",
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
    d.rounded_rectangle([40,VY+VH+40,40+lw+48,VY+VH+40+64],16,fill=(28,40,68)); d.text((64,VY+VH+52),label,font=lf,fill=AMB)
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
 card("k1",[("Todo mundo viu",WH,92),("a denúncia.",WH,92)],3.0),
 card("k2",[("Quase ninguém ouviu",WH,84),("a resposta.",AMB,84)],3.2),
 card("k3",[("A HISTÓRIA QUE",WH,96),("NINGUÉM CONTOU",AMB,96)],3.2,"Pronto-Socorro Municipal de Várzea Grande (MT)"),
 clip("a",78.50,98.98,MED,[(78.5,81.05,"Nesse período, a criança foi avaliada"),(81.05,85.7,"por duas médicas neurologistas pediátricas distintas"),(85.7,88.55,"e por um membro da equipe de neurocirurgia."),(88.55,92.0,"Ela realizou tomografia computadorizada,"),(92.0,94.6,"ressonância magnética de crânio"),(94.6,98.98,"e foi avaliada e monitorizada clinicamente 24 horas por dia.")]),
 clip("b",193.70,205.65,MED,[(193.7,197.5,"Ela chegou às 23 horas do dia 13."),(197.5,202.15,"Antes do amanhecer, da troca de plantão do dia 14 de manhã,"),(202.15,205.65,"ela já tinha os exames que descartavam qualquer emergência.")]),
 clip("c",229.12,240.50,MED,[(229.12,233.5,"Então houve total celeridade em atender a situação"),(233.5,238.95,"e atendimento integral por toda a equipe assistencial"),(238.95,240.5,"do Pronto-Socorro de Várzea Grande.")]),
 card("k4",[("Quem parou",WH,92),("para ouvir,",WH,92),("entendeu.",AMB,92)],3.0),
 clip("d",365.30,379.25,COM,[(365.3,370.4,"A médica está falando de maneira muito consciente, muito responsável."),(370.4,376.85,"Ninguém vem a público para se posicionar dessa forma mentindo."),(376.85,379.25,"Tenho certeza que ela está falando a verdade.")]),
 clip("e",412.05,419.40,COM,[(412.05,414.15,"Parabéns ao Pronto-Socorro."),(414.15,419.4,"Espero que, daqui pra frente, essa polêmica se encerre com a verdade.")]),
 card("k5",[("A primeira nota",WH,80),("da Prefeitura já dizia:",WH,80),("o protocolo foi seguido.",AMB,80)],3.6),
 card("k6",[("Mas a prefeita",WH,84),("Flávia Moretti",WH,84),("foi julgada antes",AMB,84),("de ser ouvida.",AMB,84)],3.8),
 card("k7",[("É fácil julgar",WH,104),("antes de ouvir.",AMB,104)],4.0),
 card("k8",[("Respeito ao pai.",WH,80),("Respeito a quem cuida.",WH,80),("Respeito à verdade.",AMB,80)],4.2),
]
open(f"{O}/list.txt","w").write("".join(f"file '{p}'\n" for p in seq))
subprocess.run(["ffmpeg","-v","error","-y","-f","concat","-safe","0","-i",f"{O}/list.txt","-c","copy",f"{O}/cut.mp4"],check=True)
dur=float(subprocess.check_output(["ffprobe","-v","error","-show_entries","format=duration","-of","csv=p=0",f"{O}/cut.mp4"]))
# trilha: pad grave e sóbrio, com ducking sob as falas
pad=("sine=f=110:r=48000[a1];sine=f=164.81:r=48000[a2];sine=f=220:r=48000[a3];sine=f=261.63:r=48000[a4];sine=f=55:r=48000[a5];"
     "[a1][a2][a3][a4][a5]amix=inputs=5:normalize=0:weights='0.5 0.35 0.3 0.22 0.5',tremolo=f=0.15:d=0.5,lowpass=f=900,aecho=0.8:0.7:120|260:0.4|0.3,volume=0.5,"
     f"afade=in:st=0:d=1.2,afade=out:st={dur-2.5:.2f}:d=2.5,aformat=channel_layouts=stereo[m];"
     "[0:a]asplit[s1][s2];[m][s1]sidechaincompress=threshold=0.02:ratio=12:attack=40:release=600[md];[s2][md]amix=inputs=2:normalize=0:duration=first,alimiter=limit=0.95[ao]")
subprocess.run(["ffmpeg","-v","error","-y","-i",f"{O}/cut.mp4","-filter_complex",pad,"-map","0:v","-map","[ao]","-c:v","copy","-c:a","aac","-b:a","160k","-movflags","+faststart","-t",f"{dur:.2f}",sys.argv[2]],check=True)
print("ok",dur)
