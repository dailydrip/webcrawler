alias Webcrawler.{Queue, Worker, Results}

Queue.push("http://dailydrip.com")
{:ok, worker} = Worker.start_link()
{:ok, worker2} = Worker.start_link()
{:ok, worker3} = Worker.start_link()

GenStage.sync_subscribe(worker, to: Queue, max_demand: 2, min_demand: 0)
GenStage.sync_subscribe(worker2, to: Queue, max_demand: 2, min_demand: 0)
GenStage.sync_subscribe(worker3, to: Queue, max_demand: 2, min_demand: 0)

:timer.sleep(1_000)
IO.inspect Results.list
:timer.sleep(1_000)
IO.inspect Results.list
:timer.sleep(1_000)
IO.inspect Results.list
:timer.sleep(1_000)
IO.inspect Results.list
:timer.sleep(1_000)
IO.inspect Results.list
:timer.sleep(20_000)
