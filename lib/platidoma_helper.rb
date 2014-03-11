module PlatidomaHelper

  def platidoma_client
    params = {
      shop_id: configus.platidoma.shop_id,
      login: configus.platidoma.login,
      gate_password: configus.platidoma.gate_password,
    }

    @platidoma_client ||= Platidoma::Client.new params
  end

  def build_payment_sign(order, salt)
    params = {
      amount: order.cost,
      rnd: salt
    }

    sign = platidoma_client.build_payment_sign params
  end

  def build_status_sign(order, salt)
    params = {
      rnd: salt,
      order_id: order.id,
      trans_id: order.transaction_id,
      amount: order.cost
    }

    sign = platidoma_client.build_status_sign params
  end

  def build_payment_curl(order)
    salt = rand()
    sign = build_payment_sign(order, salt)

    params = {
      amount: order.cost,
      order_id: order.id,
      email: order.user.email,
      sign: sign,
      rnd: salt
    }

    redirect_url = platidoma_client.build_payment_url params
  end

  def get_status(order)
    salt = rand()
    sign = build_status_sign(order, salt)

    params = {
      pd_shop_id: configus.platidoma.shop_id,
      pd_trans_id: order.transaction_id,
      pd_rnd: salt,
      pd_sign: sign
    }

    status = platidoma_client.get_status params
  end

  def status_nonpaid?(status)
    status == "nonpaid"
  end

  def update_payment_state(order)
    status = get_status(order)

    if !status_nonpaid?(status)
      state_event_hash = {
        paid: :pay,
        reverse: :cancel,
        refund: :refund,
        declined: :decline
      }

      order.fire_payment_state_event(state_event_hash[status.to_sym])
    end

  end

end