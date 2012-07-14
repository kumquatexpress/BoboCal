// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function(){
	$('.add_friend_button').bind('ajax:success', function(){
		$(this).closest('tr').find('.btn').val("Pending friend request");
		$(this).closest('tr').find('.btn').addClass("btn btn-warning");
	});
	$('.accept_friend_request').bind('ajax:success', function(){
		$(this).closest('tr').find('.btn').val('Gained a new friend');
		$(this).closest('tr').find('.btn').addClass("btn btn-success");
	});
	$('.decline_friend_request').bind('ajax:success', function(){
		$(this).closest('tr').find('.btn').val('Rejected');
		$(this).closest('tr').find('.btn').addClass("btn btn-danger");
	});
	
});
