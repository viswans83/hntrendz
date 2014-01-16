
Sequel.migration do
  change do
    create_table(:posts) do
      primary_key :id
      String :title
      String :url
      DateTime :track_start
      DateTime :track_end
    end

    create_table(:post_trend) do
      primary_key :id
      foreign_key :post_id, :posts
      DateTime :time_stamp
      Integer :position
      Integer :points
      Integer :comments
    end
  end
end
