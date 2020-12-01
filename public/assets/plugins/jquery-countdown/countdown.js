$(function () {
	 var austDay = new Date("March 12, 2021");
		$('#launch_date').countdown(
	{
	until: austDay,
	 layout: '<ul class="countdown"><li><span class="number">{dn}<\/span><span class="time">{dl}<\/span><\/li><li><span class="number">{hn}<\/span><span class="time">{hl}<\/span><\/li><li><span class="number">{mn}<\/span><span class="time">{ml}<\/span><\/li><li><span class="number">{sn}<\/span><span class="time">{sl}<\/span><\/li><\/ul>'
	  });
  		$('#year').text(austDay.getFullYear());
		
		
		 var austDay = new Date("December 1, 2020");
		$('#launch_date1').countdown(
	{
	until: austDay,
	 layout: '<ul class="countdown"><li><div class="count-down"><p class="number">{dn}<\/p><p class="time">{dl}<\/p><\/div><span class="colone">:<\/span><\/li><li><div class="count-down"><p class="number">{hn}<\/p><p class="time">{hl}<\/p><\/div><span class="colone">:<\/span><\/li><li><div class="count-down"><p class="number">{mn}<\/p><p class="time">{ml}<\/p><\/div><span class="colone">:<\/span><\/li><li><div class="count-down"><p class="number">{sn}<\/p><p class="time">{sl}<\/p><\/div><\/li><\/ul>'
	  });
  		$('#year').text(austDay.getFullYear());
});