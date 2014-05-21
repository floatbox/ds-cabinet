root = exports ? this

checkTime = (i) ->
  i = "0" + i if i < 10
  i

root.startTime = ->
  today = new Date()
  h = today.getHours()
  m = today.getMinutes()
  s = today.getSeconds()
  # add a zero in front of numbers<10
  m = checkTime(m);
  s = checkTime(s);
  document.getElementById('time').innerHTML = h + ":" + m + ":" + s;
  t = setTimeout ->
    startTime()
  , 1000