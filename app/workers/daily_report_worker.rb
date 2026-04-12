class DailyReportWorker
  include Sidekiq::Job

  def perform
    new_items = Item.where(created_at: 24.hours.ago..Time.current).to_a

    User.find_each do |user|
      favorite_items = user.favorites.to_a

      UserMailer.daily_report(user, new_items, favorite_items).deliver_now
    end
  end
end
