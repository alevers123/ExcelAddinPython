import os
basedir = os.path.abspath(os.path.dirname(__file__))

class Config():
    SECRET_KEY = os,environ.get("SECRET_KEY") or "NOKEYSET"

class TestingConfig(Config):
    TESTING=True
    SQLALCHEMY_DATABASE_URI = "sqlite:///" + os.path.join(basedir, "data_dev.sqlite")

class DevelopmentConfig(Config):
    DEBUG=True 