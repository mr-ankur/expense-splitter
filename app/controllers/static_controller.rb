class StaticController < ApplicationController
  before_action :load_users, only: [:dashboard, :person]
  before_action :load_person, only: [:person]
  
  def dashboard
    # Expenses
    @owe_expenses = Expense.select(:total_amount, :description).where(incurred_by_id: current_user.id)
    @owed_expenses = Expense.select(:total_amount, :description).where(paid_by_id: current_user.id)
    # owe and owed expense total
    @owe_expenses_total = @owe_expenses.pluck(:total_amount).sum
    @owed_expenses_total = @owed_expenses.pluck(:total_amount).sum
    # total balance
    @total_balance = @owed_expenses_total - current_user.splits.pluck(:amount).sum
  end

  def person
    @person_expenses = Expense.where(incurred_by_id: @person.id)
  end

  private

  def load_users 
    @users = User.all.select(:id,:name)
  end

  def load_person
    @person = User.find(params[:id])
  end
end
