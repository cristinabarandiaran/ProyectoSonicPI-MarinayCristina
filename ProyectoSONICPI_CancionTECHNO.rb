# INTRODUCION
live_loop :tambores1 do
  use_bpm 100  # Ritmo
  sample :drum_bass_hard
  sleep 0.5
  sample :drum_bass_hard
  sleep 0.5
  sample :drum_bass_hard
  sleep 0.5
  sample :drum_bass_hard
  sleep 0.25
  sample :drum_bass_hard
  sleep 0.25
  sample :drum_bass_hard
  sleep 0.25
  sample :drum_bass_hard
  sleep 0.5
  sample :drum_bass_hard
  sleep 0.25
  sample :drum_bass_hard
  sleep 0.25
  sample :drum_bass_hard
  sleep 0.6
  sample :drum_bass_hard
  sleep 0.5
  sample :drum_bass_hard
  sleep 0.5
  sample :drum_bass_hard
  sleep 0.5
  sample :drum_bass_hard
  sleep 0.25
  sample :drum_bass_hard
  sleep 0.25
  
  cue :tambores1  # Señal para el loop
  stop  # Detener el loop al final
end

# Configuramos el BPM para el resto del código.
use_bpm 100

# INTRO que dura aproximadamente 16 segundos.
# Aquí usamos un sintetizador y efectos para crear un ambiente sonoro.
with_synth :dsaw do
  # Aplicamos un efecto de "slicer" para dar un efecto de pulsación.
  with_fx(:slicer, phase: [0.25, 0.125].choose) do
    # Aplicamos reverberación para añadir espacio a la mezcla.
    with_fx(:reverb, room: 0.5, mix: 0.3) do
      # Elegimos notas iniciales y finales de una escala menor.
      start_note = chord([:b1, :b2, :e1, :e2, :b3, :e3].choose, :minor).choose
      final_note = chord([:b1, :b2, :e1, :e2, :b3, :e3].choose, :minor).choose
      
      # Tocamos la nota inicial con diversos parámetros para un sonido dinámico.
      p = play start_note, release: 10, note_slide: 4, cutoff: 30, cutoff_slide: 4, detune: rrand(0, 0.2), pan: rrand(-1, 0), pan_slide: rrand(4, 8)
      # Controlamos la nota final y otros parámetros.
      control p, note: final_note, cutoff: rrand(80, 120), pan: rrand(0, 1)
    end
  end
end

sleep 8  # Esperamos a que termine la introducción.

# SEGUNDA PARTE
# Cambiamos el ritmo a 160 BPM para una sección más rápida.
use_debug false
use_bpm 160 #180

# MEZCLADOR - definimos los niveles de volumen para diferentes elementos.
master = 1.0

base_amp = 1.7  # Amplificación de la base
snare_amp = 0.25  # Amplificación del redoblante
hihat_amp = 4.2  # --------4.2 Amplificación del hi-hat

amp_kick = 7.8  # Amplificación del bombo
bass_volume = 0.3 * amp_kick  #----------0.3 Volumen del bajo basado en la amplificación del bombo.
amp_ph6 = 0.2  # Amplificación para el sintetizador TB-303.

slicer01_amp = 2  # Amplificación para el slicer.
beep_amp = 0.5  # Amplificación para los beeps.0.5

#----------------------------------------------------------------------

# RITMOS - patrones de ritmo para diferentes elementos.
beep_rhythm = (ring 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0,
               0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0)

kick_rhythm = (ring 1, 0, 1, 0)

kick_rhythm2 = (ring 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
                1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
                1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
                1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0)

#----------------------------------------------------------------------

# TAMBORES - bucles de sonido para los elementos percusivos.
with_fx :reverb, mix: 0.5 do
  live_loop :snare3 do
    # Reproducimos el redoblante con un efecto de reverberación y ajuste de tono.
    sample  :sn_dub,
      amp: snare_amp * master,
      rate: (ring 1.75, 1.8).tick,  # Cambiamos la velocidad aleatoriamente.
      cutoff: 80
    sleep 2  # Esperamos antes de repetir.
  end
end

with_fx :reverb , mix: 0.25 do
  with_fx :ixi_techno do
    live_loop :hihat do
      # Reproducimos el hi-hat con un efecto de reverberación.
      sample :drum_cymbal_closed, amp: hihat_amp * master * base_amp, rate: ring(2, 4).tick
      sleep 0.5  # Intervalo de sueño para el hi-hat.
    end
  end
end

#----------------------------------------------------------------------

# KICKBASS - loops para el bombo y el bajo.
live_loop :kick do
  with_fx :eq, low_shelf: 0.2 do #C 8
    #sample :bd_tek, amp: amp_kick * master * (ring 1, 0.8, 1.2).tick
    sleep 0.5  # Sincronización del bombo.
    # Reproducimos el bombo con un ecualizador para ajustar la frecuencia baja.
    sample :bd_tek, amp: amp_kick * master * kick_rhythm.tick,
      beat_stretch: 0.8,
      cutoff: 90, #60
      attack: 0.025,
      release: 0.25
  end
end

live_loop :bass do
  bass_co = range(80, 60, 0.25).mirror  # Cambiamos la frecuencia de corte para el bajo.
  sleep 0.5  # Sincronización del bajo.
  with_fx :eq, low_shelf: 0.25, low_note: 15 do
    with_synth :fm do
      beep_notes1 = (ring :d2, :e2).tick  #Seleccionamos notas para el bajo.
      beep_notes2 = (ring :a2, :f2).tick
      play beep_notes1,
        decay: 0.125, #C 0.25
        release: 0.75,
        attack: 0.15,
        sustain: 0.25,
        cutoff: bass_co.look,
        amp: bass_volume * master, #(ring bass_volume, bass_volume * 2).tick,
        depth: 0.5
      
    end
  end
  sleep 0.5  # Intervalo de sueño para el bucle de bajo.
end

live_loop :squelch do
  with_fx :flanger, feedback: 0.25 do
    use_random_seed ring(300, 3000, 6000, 2000).tick  # Semilla aleatoria para variar el sonido.
    8.times do  # Repetimos 8 veces.
      with_synth :tb303 do
        n = (ring :d1, :e2, :e1).choose  # Elegimos notas aleatorias.
        play n,
          release: 0.5,
          cutoff: rrand(60, 100),
          res: 0.8,
          wave: 0,
          amp: amp_ph6 * master,
          pitch: 8
        sleep 0.5  # Intervalo de sueño para el squelch.
      end
    end
  end
end