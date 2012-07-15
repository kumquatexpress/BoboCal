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
	//user search add friend buttons
	
	$('.add_friend_button').bind('ajax:success', function(){
		$(this).closest('tr').find('.btn').val("Pending friend request");
		$(this).closest('tr').find('.btn').addClass("btn btn-warning");
	});
	$('.respond_friend_request').bind('ajax:success', function(){
		$(this).closest('tr').find('.respond_friend_request').fadeOut();
	});
		
	//event planning friend invite buttons
	
	$('.invite_friend_button').bind('ajax:success', function(textstatus, data, jqXHR){
		$(this).closest('tr').find('.btn').val("Uninvite Friend");
		$(this).closest('tr').find('.btn').addClass("btn-warning");
		$(this).removeClass('invite_friend_button').addClass('uninvite_friend_button');
	});
	$('.uninvite_friend_button').bind('ajax:success', function(textstatus, data){
		$(this).closest('tr').find('.btn').val("Invite Friend");
		$(this).closest('tr').find('.btn').removeClass('btn-warning');
		$(this).removeClass('uninvite_friend_button').addClass('invite_friend_button');
	});
});
