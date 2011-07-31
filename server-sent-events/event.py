# -*- coding: utf-8 -*-
import json
import random
import os.path
import tornado.ioloop
import tornado.web

class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/", MainHandler),
            (r"/eventsource", EventSourceHandler),
            ]
        settings = dict(
            template_path = os.path.join(os.path.dirname(__file__), "templates"),
            static_path = os.path.join(os.path.dirname(__file__), "static"),
            debug = True,
            )
        tornado.web.Application.__init__(self, handlers, **settings)


class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.render("index.html")


class EventSourceHandler(tornado.web.RequestHandler):
    clients = []

    @classmethod
    def send_event(cls, event_type, data):
        for callback in cls.clients:
            callback(event_type, data)

    @tornado.web.asynchronous
    def get(self):
        self.set_header('Content-Type', 'text/event-stream')
        EventSourceHandler.clients.append(self.async_callback(self.on_new_event))

    def on_new_event(self, event_type, data):
        if self.request.connection.stream.closed():
            return

        if event_type:
            self.write("event: %s\n" % event_type)
        self.write("data: %s\n\n" % json.dumps(data))
        self.flush()


def send_periodic_message():
    rand = random.choice([0, 1, 2, 3])
    if rand == 0:
        event_type = None
        data = {
            "from"    : "Tornado",
            "msg"     : "It's rainy over here today",
            "location": "Remote Server",
            }
    elif rand == 1:
        event_type = "direct"
        data = { "from"    : "yann",
                 "msg"     : "You should check your inbox",
                 "location": "Boston",
                 }
    elif rand == 2:
        event_type = "forward"
        data = {"from"    : "roland",
                "through" : "Sasha",
                "msg"     : "watch this! http://youtu.be/LybAHotsvOg",
                "location": "Mexico",
                }
    else:
        event_type = "checkin"
        data = { "from": "Peter",
                 "place": "StarCoffee",
                 "location": "Berlin",
                 }

    EventSourceHandler.send_event(event_type, data)

if __name__ == '__main__':
    app = Application()
    app.listen(8000)
    io_loop = tornado.ioloop.IOLoop.instance()

    scheduler = tornado.ioloop.PeriodicCallback(send_periodic_message, 5000, io_loop=io_loop)
    scheduler.start()

    io_loop.start()
