$(function(){
   
  $("input[type = 'checkbox']").click(function(){
    $("input[type = 'checkbox']").prop('checked', false).val("false")
    $(this).prop('checked', true).val("true")
  });
   
  $("#default_card_submitBtn").on("click",function(e){
    e.preventDefault()
    var cards_table_id = $("input[value = 'true']").parents(".cardList__data").attr("data-id");
    var back_url = $("input[value = 'true']").parents(".cardList__data").attr("data-back-url");
    $.ajax({
      url:"/cards/id:"+cards_table_id+"/cards",
      type: "PATCH",
      data:{cards_table_id, back_url},
      dataType: "html"
    })
    .done(function(){
      alert("カードを変更しました")
    })
    .fail(function(){
      alert("失敗しました")
    })
  });
});