// table interaction
jQuery(document).ready(function($) {	
	$('.tsc_pricingtable05 td, .tsc_pricingtable05 th')
		.on('mouseenter' , function(){
			var the_parent = $('.tsc_pricingtable05');
			the_parent.find('*').removeClass('border_blue');
			var index = $(this).index();
			the_parent.find('tr').each(function(i){
				var item = $(this);
				if(item.hasClass('grey')){
					item.find('th:eq('+index+') , td:eq('+index+')').addClass('w_table_l_grey');
				}else{
					item.find('th:eq('+index+') , td:eq('+index+')').addClass('w_table_d_grey');
				}
			});
		})
		.on('mouseleave' , function(){
			$('.tsc_pricingtable05').find('*').removeClass('w_table_d_grey').removeClass('w_table_l_grey');
		});
		
	$('.tsc_pricingtable06 td, .tsc_pricingtable06 th')
		.on('mouseenter' , function(){
			var the_parent = $('.tsc_pricingtable06');
			
			the_parent.find('*').removeClass('pricing_blue_btn');
			var index = $(this).index();
			the_parent.find('tr').each(function(i){
				var item = $(this);
				if(item.hasClass('grey')){
					item.find('th:eq('+index+') , td:eq('+index+')').addClass('d_table_l_grey');
				}else{
					item.find('th:eq('+index+') , td:eq('+index+')').addClass('d_table_d_grey');
				}
			});
		})
		.on('mouseleave' , function(){
			$('.tsc_pricingtable06').find('*').removeClass('d_table_l_grey').removeClass('d_table_d_grey');
		});
});
	// table interaction END 
	
