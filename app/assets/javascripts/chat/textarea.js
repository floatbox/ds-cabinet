$(function(){

$('#message_text').keyup(function(){
    $(this).height(24); //x/ min-height
    if (this.scrollHeight >= 43)  {
    	$(this).height(this.scrollHeight+1);
    }
})

});
