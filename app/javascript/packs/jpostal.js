jQuery(document).on("turbolinks:load", function() {
  $('#user_postcode').jpostal({
    postcode : [
      // 取得する郵便番号のテキストボックスをidで指定
      '#user_postcode'
    ],
    address: {
      // %3 => 都道府県、 %4 => 市区町村 %5 => 町域 %6 => 番地 %7 => 名称
      // それぞれを表示するコントロールをidで指定
      "#user_prefecture_code"  : "%3",
      "#user_address_city"   : "%4%5",
      "#user_address_street" : "%6%7"
    }
  });
});

