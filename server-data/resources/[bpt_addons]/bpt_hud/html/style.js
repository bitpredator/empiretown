$(document).ready(function(){
    window.addEventListener('message', function(event) {
        var data = event.data;
		if (data.show == false){
			if (data.posi == "bottom"){
		$("body").show();
   		soMany = 50-data.health;
		document.querySelectorAll('.wave')[0].style.setProperty("--top", `${soMany}%`);
		
		armorJS = 50 - data.armor
        document.querySelectorAll('.wave2')[0].style.setProperty("--top", `${armorJS}%`);
		
		foodJS = 50 - data.food
		document.querySelectorAll('.wave3')[0].style.setProperty("--top", `${foodJS}%`);
		
		waterJS = 50 - data.thirst
        document.querySelectorAll('.wave4')[0].style.setProperty("--top", `${waterJS}%`);
		}
		else
		{
		    $(".main").css("top", "15vh");
			$(".main").css("right", "5vw");
			$("body").show();
			soMany = 50-data.health;
			document.querySelectorAll('.wave')[0].style.setProperty("--top", `${soMany}%`);
				
			armorJS = 50 - data.armor
			document.querySelectorAll('.wave2')[0].style.setProperty("--top", `${armorJS}%`);
				
			foodJS = 50 - data.food
			document.querySelectorAll('.wave3')[0].style.setProperty("--top", `${foodJS}%`);
				
			waterJS = 50 - data.thirst
			document.querySelectorAll('.wave4')[0].style.setProperty("--top", `${waterJS}%`);	
		}}
		else
		{
			$("body").hide();
		}
    });
});