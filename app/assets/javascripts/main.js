$(function(){
	// functions are attached to window because they must be global in scope
		var player;

		window.onYouTubeIframeAPIReady = function() {
			player = new YT.Player('video_embed', {
		    	events: {
		      		'onReady': window.onPlayerReady,
		      		'onStateChange': window.onPlayerStateChange
		    	}
		  	});

		}

		window.onPlayerReady = function(event) {}
		window.onPlayerStateChange = function(event) {
			// close video when it finishes	and reset to beginning
			if (event.data == 0) {
				closeVideo();
				setTimeout(function() {
					if (typeof(player.seekTo) != "undefined") {
						player.seekTo(0);
					}
				}, 0);									
			}
		}
		
		openVideo = function() {
			// ESC to dismiss
			$(window.document).bind('keydown.esc', function(e) {
				console.log('keydown');
				if (e.which == 27) {
					console.log('ESC');
					closeVideo();
				}
			});

			if (navigator.userAgent.match(/(iPad)/)) {
				// reload video on iPad
				document.getElementById('video_embed').src = document.getElementById('video_embed').src;
			} else {
				if (typeof(player.playVideo) != "undefined") {
					player.playVideo();	
				}									
			}
		
		}
					
		closeVideo = function() {
			if (typeof(player.stopVideo) != "undefined") {
				player.stopVideo();
			}
			$('body').css('overflow', 'auto');
			$('#showVideo').modal('hide');
			$(window.document).unbind('keydown.esc');
		}
	
		$('#playVideo').on('click', function(e) {	
			openVideo();
			$('#showVideo').modal('show');								
		});
			
		
		$('#showVideo').on('click', function(e) {	
			closeVideo();								
		});
		//$('#video_close_btn').on('click', closeVideo);

	var body = $("html, body");
	if($('.js__switcher').length){

		$('.js__switcher').switcher();
		
		var a='switch_status',
			b='switch_field',
			c='switch_field_on',
			s1='Я являюсь ИП',
			s2='Я не являюсь ИП';
		
		$('#switch_btn1').click(function(){
			$('#'+a).html(s1);
			$('.'+b).removeClass('lock').show();
			$('.'+c).addClass('hide');
			});
			
		$('#switch_btn2').click(function(){
			$('#'+a).html(s2);
			$('.'+b).addClass('lock').hide();
			$('.'+c).removeClass('hide');
			});
	};
	
	$('.case-intro .ttl').click(function(){
		var class_fl = $(this).attr('data-fl');
		$('.case-intro .ttl').removeClass('active');
		$(this).addClass('active');
		$('.tb_fields > tbody > tr').hide();
		$('.'+class_fl+':not(.lock)').show();
	});
	
	$('.case-regin .reg').click(function(){
		$('.ttl[data-fl="regi_fl"]').trigger('click');
		body.animate({scrollTop:0}, 500, 'swing', function() { 
		});
	});
	
	$('.case-regin .enter').click(function(){
		$('.ttl[data-fl="enter_fl"]').trigger('click');
		body.animate({scrollTop:0}, 500, 'swing', function() { 
		});
	});
});


