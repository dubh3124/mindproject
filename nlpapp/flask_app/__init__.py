from flask import Flask
from flask_app.config import config


def create_app(config_name):
    app = Flask(__name__)

    app.config.from_object(config["development"])
    app.logger.info("Config: %s" % config_name)

    #  Logging
    import logging

    logging.basicConfig(
        level=app.config["LOG_LEVEL"],
        format="%(asctime)s %(levelname)s: %(message)s " "[in %(pathname)s:%(lineno)d]",
        datefmt="%Y%m%d-%H:%M%p",
    )

    # CORS
    from flask_cors import CORS

    CORS(app, supports_credentials=True)

    # Business Logic
    # http://flask.pocoo.org/docs/patterns/packages/
    # http://flask.pocoo.org/docs/blueprints/
    from flask_app.apiv1 import api1

    app.register_blueprint(api1)

    return app
