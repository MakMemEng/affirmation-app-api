require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "User" do
    it "should be valid" do
      expect(user).to be_valid
    end
  end

  describe "name" do
    max = 30

    it "name_validation" do
      # 入力必須
      user = User.new(email: "test@example.com", password: "password")
      user.save
      required_msg = ["名前を入力してください"]
      assert_equal(required_msg, user.errors.full_messages)

      # 文字数制限
      max = 30
      name = "a" * (max + 1)
      user.name = name
      user.save
      maxlength_msg = ["名前は30文字以内で入力してください"]
      assert_equal(maxlength_msg, user.errors.full_messages)

      # 30文字以内は正しく保存されているか
      name = "あ" * max
      user.name = name
      assert_difference("User.count", 1) do
        user.save
      end
    end

  end

  describe "email" do

    it "email_validation" do
      # 入力必須
      user = User.new(name: "test", password: "password")
      user.save
      required_msg = ["メールアドレスを入力してください"]
      assert_equal(required_msg, user.errors.full_messages)

      # 文字数制限
      max = 255
      domain = "@example.com"
      email = "a" * ((max + 1) - domain.length) + domain
      assert max < email.length

      user.email = email
      user.save
      maxlength_msg = ["メールアドレスは255文字以内で入力してください"]
      assert_equal(maxlength_msg, user.errors.full_messages)

      # 書式チェック format = /\A\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*\z/
      ok_emails = %w(
        A@EX.COM
        a-_@e-x.c-o_m.j_p
        a.a@ex.com
        a@e.co.js
        1.1@ex.com
        a.a+a@ex.com
      )
      ok_emails.each do |email|
        user.email = email
        assert user.save
      end

      ng_emails = %w(
        aaa
        a.ex.com
        メール@ex.com
        a~a@ex.com
        a@|.com
        a@ex.
        .a@ex.com
        a＠ex.com
        Ａ@ex.com
        a@?,com
        １@ex.com
        "a"@ex.com
        a@ex@co.jp
      )
      ng_emails.each do |email|
        user.email = email
        user.save
        format_msg = ["メールアドレスは不正な値です"]
        assert_equal(format_msg, user.errors.full_messages)
      end
    end


    it "should be unique" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save!
    end

    it "should be saved as lower-case" do
      user.email = "Foo@ExAMPle.CoM"
      user.save!
      expect(user.reload.email).to eq 'foo@example.com'
    end
  end

  describe "activated" do

    it "active_user_uniqueness" do
      email = "test@example.com"
      # アクティブユーザーがいない場合、同じemailが保存できているか
      count = 3
      assert_difference("User.count", count) do
        count.times do |n|
          User.create(name: "test", email: email, password: "password")
        end
      end
      # アクティブユーザーがいる場合、同じemailでバリデーションエラーを吐いているか
      active_user = User.find_by(email: email)
      active_user.update!(activated: true)
      assert active_user.activated

      assert_no_difference("User.count") do
        user = User.new(name: "test", email: email, password: "password")
        user.save
        uniqueness_msg = ["メールアドレスはすでに存在します"]
        assert_equal(uniqueness_msg, user.errors.full_messages)
      end

      # アクティブユーザーがいなくなった場合、同じemailが保存できているか
      active_user.destroy!
      assert_difference("User.count", 1) do
        User.create(name: "test", email: email, password: "password", activated: true)
      end

      # アクティブユーザーのemailの一意性は保たれているか
      assert_equal(1, User.where(email: email, activated: true).count)
    end

  end

  describe "password" do
    it "password_validation" do
      # 入力必須
      user = User.new(name: "test", email: "test@example.com")
      user.save
      required_msg = ["パスワードを入力してください"]
      assert_equal(required_msg, user.errors.full_messages)

      # 8文字以上
      min = 8
      user.password = "a" * (min - 1)
      user.save
      minlength_msg = ["パスワードは8文字以上で入力してください"]
      assert_equal(minlength_msg, user.errors.full_messages)

      # 最大72文字まで
      max = 72
      user.password = "a" * (max + 1)
      user.save
      maxlength_msg = ["パスワードは72文字以内で入力してください"]
      assert_equal(maxlength_msg, user.errors.full_messages)

      # 書式チェック
      ok_passwords = %w(
        pass---word
        ________
        12341234
        ____pass
        pass----
        PASSWORD
      )
      ok_passwords.each do |pass|
        user.password = pass
        assert user.save
      end

      ng_passwords = %w(
        pass/word
        pass.word
        |~=?+"a"
        １２３４５６７８
        ＡＢＣＤＥＦＧＨ
        password@
      )
      format_msg = ["パスワードは半角英数字•ﾊｲﾌﾝ•ｱﾝﾀﾞｰﾊﾞｰが使えます"]
      ng_passwords.each do |pass|
        user.password = pass
        user.save
        assert_equal(format_msg, user.errors.full_messages)
      end
    end

  end

end
