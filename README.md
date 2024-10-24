# nlsr-example

<center><img src=image.png width=60%></center>

## コンテナを起動する

```bash
cd nlsr-example
docker-compose up -d
```

**Router is ready** となればOK

```bash
docker-compose logs router1
```

## コンテンツを配信する

提供するコンテンツ(hello.txt)を作成する

```bash
docker-compose exec router1 bash -c "echo 'Hello, world!' > hello.txt"
```

コンテンツ名(/sample.txt)を広告する

```bash
docker-compose exec router1 bash -c "nlsrc advertise /hello"
```

作成したコンテンツを提供する

```bash
docker-compose exec -it producer bash -c "ndnputchunks /hello < hello.txt"
```

コンテンツを要求する (別ターミナル)

```bash
docker-compose exec router2 ndncatchunks /hello
```

## コンテナを削除する

```bash
docker-compose donw -v
```
