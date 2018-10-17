module OpSSL
  class OpSSL
    def initializer
    end

    def genpkey(user, pass)
      IO.popen("openssl genpkey -algorithm RSA -out ~/.keysdat/"+user+"_pkey.pem -aes-256-cbc -pass pass:"+pass)
    end

    def genpbkey(user, pass)
      IO.popen("openssl rsa -pubout -in ~/.keysdat/"+user+"_pkey.pem -passin pass:"+pass+" -out ~/.keysdat/"+user+"_pbkey.pem")
    end

    def encrypt(user, data)
      IO.popen("echo '"+data+"' | openssl rsautl -encrypt -inkey ~/.keysdat/"+user+"_pbkey.pem -pubin | xxd -p -c 999") do |f|
        f.gets
      end
    end

    def decrypt(user, pass, data)
      IO.popen("echo '"+data+"' | xxd -p -r | openssl rsautl -decrypt -inkey ~/.keysdat/"+user+"_pkey.pem -passin pass:"+pass) do |f|
        f.gets.chomp
      end
    end

    def del_pub(user)
      IO.popen("rm ~/.keysdat/"+user+"_pbkey.pem")
    end

    def del_pkey(user)
      IO.popen("rm ~/.keysdat/"+user+"_pkey.pem")
    end
  end
end