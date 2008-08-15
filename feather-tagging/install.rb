# Install the dm-tags tables
Database::migrate(Tag)
Database::migrate(Tagging)

# alter the Article table

DataMapper.auto_upgrade!
