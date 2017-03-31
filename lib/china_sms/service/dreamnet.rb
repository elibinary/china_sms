# encoding: utf-8

module ChinaSMS
  module Service
    module Dreamnet
      extend self
      
      ERROR_MAP = {
        '-1' =>  '参数为空。信息、电话号码等有空指针，登陆失败',
        '-2' => '电话号码个数超过100',
        '-10' => '申请缓存空间失败',
        '-11' => '电话号码中有非数字字符',
        '-12' => '有异常电话号码',
        '-13' => '电话号码个数与实际个数不相等',
        '-14' => '实际号码个数超过100',
        '-101' => '发送消息等待超时',
        '-102' => '发送或接收消息失败',
        '-103' => '接收消息超时',
        '-200' => '其他错误',
        '-999' => 'web服务器内部错误',
        '-10001' => '用户登陆不成功',
        '-10002' => '提交格式不正确',
        '-10003' => '用户余额不足',
        '-10004' => '手机号码不正确',
        '-10005' => '计费用户帐号错误',
        '-10006' => '计费用户密码错',
        '-10007' => '账号已经被停用',
        '-10008' => '账号类型不支持该功能',
        '-10009' => '其它错误',
        '-10010' => '企业代码不正确',
        '-10011' => '信息内容超长',
        '-10012' => '不能发送联通号码',
        '-10013' => '操作员权限不够',
        '-10014' => '费率代码不正确',
        '-10015' => '服务器繁忙',
        '-10016' => '企业权限不够',
        '-10017' => '此时间段不允许发送',
        '-10018' => '经销商用户名或密码错',
        '-10019' => '手机列表或规则错误',
        '-10021' => '没有开停户权限',
        '-10022' => '没有转换用户类型的权限',
        '-10023' => '没有修改用户所属经销商的权限',
        '-10024' => '经销商用户名或密码错',
        '-10025' => '操作员登陆名或密码错误',
        '-10026' => '操作员所充值的用户不存在',
        '-10027' => '操作员没有充值商务版的权限',
        '-10028' => '该用户没有转正不能充值',
        '-10029' => '此用户没有权限从此通道发送信息',
        '-10030' => '不能发送移动号码',
        '-10031' => '手机号码(段)非法',
        '-10032' => '用户使用的费率代码错误',
        '-10033' => '非法关键词',
        '-10057' => '非法IP地址',
        '-10123' => '定时发送时间被禁止',
        '-10124' => '无效定时发送时间',
        '-10125' => '短信有效存活时间被禁止',
        '-10126' => '短信有效存活时间无效',
        '-10252' => '业务类型错误',
        '-10253' => '自定义参数错误',
        '-10254' => '短信有效存活时间被禁止',
        '-20001' => '文件MD5校验失败',
        '-20002' => '文件块缺失',
        '-20003' => '文件流水号不存在'
      }

      URL = "http://tempuri.org/MWGate/wmgw.asmx/MongateCsSpSendSmsNew"

      # phones 最大不能超过 1000
      # content 不超过 990 个汉字
      # 必须传 URL 参数
      def to(phones, content, options)
        phones_str = Array(phones).join(',')
        body = {
          userId: options[:username],
          password: options[:password],
          pszMobis: phones_str,
          pszMsg: content,
          iMobiCount: Array(phones).length,
          pszSubPort: '*'
        }

        # body.merge!(options.slice(:iMobiCount, :pszSubPort, :SvrType, :MsgId, :ModuleId, :Attime, :Validtime, :RptFlag))
        option_params = options.select {|key, value| [:iMobiCount, :pszSubPort, :SvrType, :MsgId, :ModuleId, :Attime, :Validtime, :RptFlag].freeze.include?(key) }
        body.merge!(option_params)

        res = Net::HTTP.post_form(URI.parse(URL), body)
        result res.body
      end

      def result body
        code = body.match(/.+\<string.+\>(.+)\<\/string/)[1]
        msg = ERROR_MAP[code.to_s]
        {
          success: msg.nil?,
          code: code,
          message: msg
        }
      end

    end
  end
end