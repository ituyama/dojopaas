#!/usr/bin/env ruby

class SakuraServer

  require 'httpclient'

  SAKURA_BASE_URL     = 'https://secure.sakura.ad.jp/cloud/zone'
  SAKURA_ZONE_ID      = 'is1b'
  SAKURA_CLOUD_SUFFIX = 'api/cloud'
  SAKURA_API_VERSION  = '1.1'

  SAKURA_TOKEN        = ENV.fetch('SAKURA_TOKEN')
  SAKURA_TOKEN_SECRET = ENV.fetch('SAKURA_TOKEN_SECRET')

  # jsのserver.createで使っているフィールドを参考
  def initialize(zone:0, plan:nil, packetfilterid:nil, name:nil, description:nil, 
                 tags:nil, pubkey:nil, disk:nil, resolve:nil, notes:nil)
    @zone           = zone
    @plan           = plan
    @packetfilterid = packetfilterid
    @name           = name
    @description    = description
    @tags           = tags
    @pubkey         = pubkey
    @disk           = disk
    @resolve        = resolve
    @notes          = notes

    @client = HTTPClient.new
    @client.set_proxy_auth(SAKURA_TOKEN, SAKURA_TOKEN_SECRET)
  end

  # server.createに対応
  # 引数があると、オブジェクトの状態を変えつつそちらを使う
  def create(server_params)
    create_server_instance()
    create_network_interface()
  end

  private

  # createとdestroyで独自に引数を取れるようにしておく

  #インスタンス作成
  def create_server_instance(params)
    puts "Create a server for #{@name}."
    params = {
      :Zone => @zone, :ServerPlan => @plan, :Name => @name,
      :Description => @description, :Tags => @tags
    }
    send_request('post', 'server', 'server', params)
  end

  #ネットワークインターフェイスの作成
  def create_network_interface(params)
    params = {
      :Zone => @zone, :ServerPlan => @plan, :Name => @name, 
      :Description => @description, :Tags => @tags
    }
    send_request('post', 'server', 'server', params)
  end


  # URI(エンドポイント)を作成する
  def create_endpoint(path)
    "#{SAKURA_BASE_URL}/#{SAKURA_ZONE_ID}/#{SAKURA_CLOUD_SUFFIX}/#{SAKURA_API_VERSION}/#{path}"
  end

  # 実際に送信する
  def send_request(http_method,path,query)
    endpoint = create_endpoint(path)
    @client.send(http_method,endpoint,:query => query)
  end
end


# main

# sakuraserverのインスタンスを作成し、createする流れ
# おそらくclassの部分は切り貼りし、mainは実際には使わないのでテスト実装

sakura =  SakuraServer.new(zone: 5, tags:"test")

#sakura.create() <- createする際はこれを呼び出す

