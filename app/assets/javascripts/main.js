$(function(){
	var body = $("html, body");
	if($('.js__switcher').length){

		$('.js__switcher').switcher();
		
		var a='switch_status',
			b='switch_field',
			s1='Я являюсь ИП',
			s2='Я не являюсь ИП';
		
		$('#switch_btn1').click(function(){
			$('#'+a).html(s1);
			$('#'+b).show();
			});
			
		$('#switch_btn2').click(function(){
			$('#'+a).html(s2);
			$('#'+b).hide();
			});
	};
	
	$('.case-intro .ttl').click(function(){
		var class_fl = $(this).attr('data-fl');
		$('.case-intro .ttl').removeClass('active');
		$(this).addClass('active');
		$('.tb_fields > tbody > tr').hide();
		$('.'+class_fl).show();
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


