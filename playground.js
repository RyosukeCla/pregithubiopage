$(function(){
	//ここにjQueryの記述
	/*
	$("A").B();
	AをBする
	$(“#hoge”) – idセレクタ
    $(“.hogehoge”) – クラスセレクタ
    $(“li a”) – 子孫セレクタ
    $(“p.hoge, p.hogehoge”) – グループセレクタ
	*/

	$(".hoge2").css("color", "red");

	$(".hoge3").click(function(){
		$(".hoge3").css("background-color", "green")
	});
});

$(function(){
	$(".hoge4").click(function(){
		$(".hoge4").fadeOut(2000)
	});
});

$(function(){
	$(".hoge5").hover(
		function(){
		    $(".red").css("background", "red")
		    .text("はなすと戻るよ")
	    },
	    function(){
	    	$(".red").css("background", "#FC9")
	    	.text("")
	    });
});