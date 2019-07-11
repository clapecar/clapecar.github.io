//cambio el estilo del vídeo
		function cambioStyle(enMarcha, id){
			var nomV = "videosbox"+id;
			var video = document.getElementById(nomV);
			if(enMarcha){				
				video.style.background = '#FFCBC0';
			}
			else{
				video.style.background = 'rgba(255, 203, 192, .5)';
			}
			video.style.transition = "background 1s";
		}
		function playpause(id) { 
			var video = document.getElementById("vid" + id);
			video.playbackRate = 1.0; //por si se habia aumentado la velocidad			
			if(video.paused){
				video.play();
				cambioStyle(true, id); //cambia el estilo de fondo
				document.getElementById("play"+id).style.backgroundImage = "url('pics/controlVideo/pause.png')";
			}
			else{
				video.pause();
				cambioStyle(false, id);
				document.getElementById("play"+id).style.backgroundImage = "url('pics/controlVideo/play.png')";
			}
		}
		function stop(id) { 
			var video = document.getElementById("vid" + id);  
			video.pause(); 
			video.currentTime = 0;			
			document.getElementById("play"+id).style.backgroundImage = "url('pics/controlVideo/play.png')";
			cambioStyle(false, id);
		}
		function avanz(id){
			var video = document.getElementById("vid" + id);
			video.playbackRate = 5.0;
		}
		function actualizVolumen(id){
			vol = document.getElementById("volumen" + id);
			var video = document.getElementById("vid" + id);  
            video.volume = vol.value;
			if(vol.value == 0.0){
				document.getElementById('imgVol' + id).src="pics/controlVideo/volN.png";
			}
			else{
				document.getElementById('imgVol' + id).src="pics/controlVideo/volS.png";
			}
		}
		function cambiaVolumen(id){
			vol = document.getElementById("volumen" + id);
			var video = document.getElementById("vid" + id);  
      
			if(vol.value > 0.0){
				document.getElementById('imgVol' + id).src="pics/controlVideo/volN.png";
				vol.value = 0.0;
				video.volume = vol.value;
			}
			else{
				document.getElementById('imgVol' + id).src="pics/controlVideo/volS.png";
				vol.value = 1.0;
				video.volume = vol.value;
			}
		}
		function pantallaCompleta(id){
			var video = document.getElementById("vid" + id);
			if (video.webkitRequestFullscreen)
                video.webkitRequestFullscreen();
			if (video.mozRequestFullscreen)
                video.mozRequestFullscreen();
			if (video.msRequestFullscreen)
                video.msRequestFullscreen();
			if (video.requestFullscreen)
                video.requestFullscreen();
		}
		function cargar(id) {			
			video = document.getElementById("vid" + id);
			tiempo = document.getElementById("tiempo" + id);
			barraProg = document.getElementById("progress" + id);
			barraProg.setAttribute("max",video.duration);
			var min = parseInt(video.duration);
			var segTot = parseInt(min % 60);
			if (segTot < 10){
				segTot = "0"+segTot;
			}
			texto = document.createTextNode("0:00/" + parseInt(min/60) + ":" + segTot);
			tiempo.appendChild(texto); 
        }

		function actualizaTiempo(id){			
			video = document.getElementById("vid" + id);
			tiempo = document.getElementById("tiempo" + id);
			barraProg = document.getElementById("progress" + id);
			var min = parseInt(video.duration);
			var minAct = parseInt(video.currentTime);
			var segAct = parseInt(minAct % 60);
			if (segAct < 10){
				segAct = "0"+segAct;
			}
			var segTot = parseInt(min % 60);
			if (segTot < 10){
				segTot = "0"+segTot;
			}
			tiempo.innerHTML = (parseInt(minAct/60) + ":" + segAct + "/" + parseInt(min/60) + ":" + segTot); 
			barraProg.setAttribute("value", video.currentTime);
		}
		function mueveBarra(ev, id){
			barraProg = document.getElementById("progress" + id);
			video = document.getElementById("vid" + id);
			
			//Como la barra se introduce en una tabla, se ben tomar
			//las distancias de td-table-cuerpo
			var desplX = ev.clientX - 
			(barraProg.offsetParent.offsetLeft + 
			barraProg.offsetParent.offsetParent.offsetLeft +
			barraProg.offsetParent.offsetParent.offsetParent.offsetLeft);
			
            if (desplX > 0 && desplX < barraProg.clientWidth){
                video.currentTime = video.duration * (desplX / barraProg.clientWidth); 
            }
		}
		