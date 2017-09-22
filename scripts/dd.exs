alias Webcrawler.{Queue, Worker, Results}

Queue.push("http://dailydrip.com")
{:ok, worker} = Worker.start_link()

GenStage.sync_subscribe(worker, to: Queue, max_demand: 2, min_demand: 0)

:timer.sleep(1_000)
Results.list
:timer.sleep(1_000)
Results.list
:timer.sleep(1_000)
Results.list
:timer.sleep(1_000)
Results.list
:timer.sleep(1_000)
Results.list
:timer.sleep(10_000)
