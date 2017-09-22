alias Webcrawler.{Queue, Worker}

Queue.push("http://google.com")
Queue.push("http://google.com/1")
Queue.push("http://google.com/2")
Queue.push("http://google.com/3")
Queue.push("http://google.com/4")
Queue.push("http://google.com/5")
Queue.push("http://google.com/6")
{:ok, worker} = Worker.start_link()

GenStage.sync_subscribe(worker, to: Queue, max_demand: 2, min_demand: 0)

:timer.sleep(1_000)

IO.puts "pushing 7 - does he work it?"
Queue.push("http://google.com/7")

:timer.sleep(10_000)
