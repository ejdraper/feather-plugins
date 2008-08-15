# alter the Article table, wang in the frozen tags list
Database::upgrade(Article)
# Install the dm-tags tables
Database::migrate(Tag)
Database::migrate(Tagging)
