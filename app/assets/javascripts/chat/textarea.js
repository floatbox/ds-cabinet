$(function(){

$('#message_text').keyup(function(){
    $(this).height(42); //x/ min-height
    if (this.scrollHeight >= 72)  {
    	$(this).height(this.scrollHeight-22);
    }
})
$("#add-upload-file").click(function() {
    //$("#attachment_attachment").trigger('click');
    console.log('erererer')
})

});
