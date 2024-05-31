# settings.py
DATABASES = {
    'default': {
        'ENGINE': 'django_cassandra_engine',
        'NAME': 'cinema',
        'HOST': 'localhost',  # Cassandra host
        'PORT': 9042,
        'USER': 'your_cassandra_user',
        'PASSWORD': 'your_cassandra_password',
    }
}
