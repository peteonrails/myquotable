require 'test_helper'

class QuotesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:quotes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_quote
    assert_difference('Quote.count') do
      post :create, :quote => { }
    end

    assert_redirected_to quote_path(assigns(:quote))
  end

  def test_should_show_quote
    get :show, :id => quotes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => quotes(:one).id
    assert_response :success
  end

  def test_should_update_quote
    put :update, :id => quotes(:one).id, :quote => { }
    assert_redirected_to quote_path(assigns(:quote))
  end

  def test_should_destroy_quote
    assert_difference('Quote.count', -1) do
      delete :destroy, :id => quotes(:one).id
    end

    assert_redirected_to quotes_path
  end
end
