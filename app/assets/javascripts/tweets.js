//初回読み込み、リロード、ページ切り替えで動く。
$(document).on('turbolinks:load', function () {
  $('#tweets').infiniteScroll({
    path: "nav.pagination a[rel=next]",
    append: ".tweet",
    history: false,
    prefill: true,
    status: '.page-load-status',
  })
});
