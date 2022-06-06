function log-test
  set container $argv[1]
  docker start $container && docker logs -f $container || docker stop $container
end
