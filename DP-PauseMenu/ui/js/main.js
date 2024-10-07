var timerVar = setInterval(countTimer, 1000)
var totalSeconds = 0
let menu = false

$(function(){
    window.addEventListener("message", function(e){
        let data = e.data

        if (data.action == "setData"){
            $(".id span").text(data.id)
            $(".bank").text(new Intl.NumberFormat().format(data.bank)+" $")
            $(".name").text(data.name)
            $(".job").text(data.job)
            $(".grade").text(data.grade)
            $("body").fadeIn(100)
        }
    })

    $.post(`https://${GetParentResourceName()}/loaded`, function (tabs) {
        tabs.forEach(tab => {
            let text = ''

            for (let i = 0; i < tab.contents.length; i++){
                text += `
                <div class="content">
                    <div class="title">
                        <span>${tab.contents[i].title}</span>                                
                    </div>
                    <div class="desc">${tab.contents[i].desc}</div>
                </div>`
            }

        });
    })

    $(".map").click(function() {
        $("body").fadeOut(100)
        $.post(`https://${GetParentResourceName()}/event`, JSON.stringify("map"))
        reset()
    })

    $(".settings").click(function() {
        $("body").fadeOut(100)
        $.post(`https://${GetParentResourceName()}/event`, JSON.stringify("settings"))
        reset()
    })

    $(".exit").click(function() {
        $("body").fadeOut(100)
        $.post(`https://${GetParentResourceName()}/event`, JSON.stringify("close"))
    })
})


function countTimer() {
	++totalSeconds
	var hour = Math.floor(totalSeconds / 3600)
	var minute = Math.floor((totalSeconds - hour * 3600) / 60)
	var seconds = totalSeconds - (hour * 3600 + minute * 60)
	if (hour < 10) hour = "0" + hour
	if (minute < 10) minute = "0" + minute
	if (seconds < 10) seconds = "0" + seconds

	document.querySelector(".time span").innerHTML = hour + ":" + minute + ":" + seconds
}

$(window).on("keydown", function ({ originalEvent: { key } }) {
    if (key == "Escape") {
        $("body").fadeOut(100)
        $.post(`https://${GetParentResourceName()}/event`, JSON.stringify("resume"))
        reset()
    }
})