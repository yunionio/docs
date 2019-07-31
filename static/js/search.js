$(function(){
	$('input.search-input').keyup(function(){
	     var t= $(this), v = t.val();
	     $('.collapse').each(function(){
	         $(this).removeClass("show")
         });
	     $('#docs:first-child').addClass("show");
		 $('#td-section-nav .td-sidebar-link').each(function(){
			 var link = $(this), txt = link.text();
			 var index = txt.indexOf(v);
			 if(index>-1){
				 link.parents().each(function(){
				      if($(this).hasClass("collapse")){
						  $(this).addClass("show")
                      }
                 });
				 var substr = txt.substring(index , index+v.length);
				 var searchTxt = txt.replace(substr , '<span style="background:yellow">'+substr+'</span>')
				 link.html(searchTxt)
             }
		})
    })
});
