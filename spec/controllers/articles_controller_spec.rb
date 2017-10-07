require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  test_size = 5

  let(:article)  { FactoryGirl.create(:article) }
  let(:articles) { FactoryGirl.create_list(:article, test_size) }

  describe 'before_action' do
    subject { controller }

    describe ':set_article' do
      before do
        allow(controller).to receive(:set_article).and_call_original
      end

      context '#index' do
        before { get :index }
        it { is_expected.not_to have_received(:set_article) }
      end

      context '#show' do
        before { get :show, params: { id: article.id } }
        it { is_expected.to have_received(:set_article) }
      end

      describe '#new' do
        before { get :new }
        it { is_expected.not_to have_received(:set_article) }
      end

      describe '#edit' do
        before { get :edit, params: { id: article.id } }
        it { is_expected.to have_received(:set_article) }
      end

      describe '#create' do
        before { post :create }
        it { is_expected.not_to have_received(:set_article) }
      end

      describe '#update' do
        before { patch :update, params: { id: article.id } }
        it { is_expected.to have_received(:set_article) }
      end

      describe '#destroy' do
        before { get :destroy, params: { id: article.id } }
        it { is_expected.to have_received(:set_article) }
      end
    end
  end

  describe '#index' do
    before do
      articles
      get :index
    end
    it { expect(assigns[:articles].size).to eq test_size }
    it { expect(response).to render_template :index }
  end

  describe '#show' do
    context '存在しない記事を指定する場合' do
      subject { proc { get :show, params: { id: -1 } } }
      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end

    context '存在する記事を指定する場合' do
      before { get :show, params: { id: article.id } }
      it { expect(response).to render_template :show }
    end
  end

  describe '#new' do
    before { get :new }
    it { expect(assigns[:article]).to be_a_new(Article) }
    it { expect(response).to render_template :new }
  end

  describe '#edit' do
    context '存在しない記事を指定する場合' do
      subject { proc { get :edit, params: { id: -1 } } }
      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end

    context '存在する記事を指定する場合' do
      before { get :edit, params: { id: article.id } }
      it { expect(response).to render_template :edit }
    end
  end

  describe '#create' do
    context 'saveに失敗する場合' do
      before do
        allow_any_instance_of(Article).to receive(:save).and_return(false)
        get :create
      end

      it { expect(Article.count.zero?).to be_truthy }
      it { expect(response).to render_template :new }
    end

    context 'saveに成功する場合' do
      before do
        parameters = {
          article: {
            title:   article.title,
            content: article.content,
            author:  article.author
          }
        }
        get :create, params: parameters
      end

      it { expect(Article.count.zero?).to be_falsey }
      it { expect(assigns[:article].title).to   eq article.title }
      it { expect(assigns[:article].content).to eq article.content }
      it { expect(assigns[:article].author).to  eq article.author }
      it { expect(response).to redirect_to assigns[:article] }
    end
  end

  describe '#update' do
    context '存在しない記事を指定する場合' do
      subject { proc { put :update, params: { id: -1 } } }
      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end

    context '存在する記事を指定する場合' do
      let(:parameters) do
        {
          title:   "#{article.title}_after",
          content: "#{article.content}_after",
          author:  "#{article.author}_after"
        }
      end

      context 'updateに失敗する場合' do
        before do
          allow_any_instance_of(Article).to receive(:update).and_return(false)
          put :update, params: { id: article.id, article: parameters }
        end

        it { expect(assigns[:article].title).to   eq article.title }
        it { expect(assigns[:article].content).to eq article.content }
        it { expect(assigns[:article].author).to  eq article.author }
        it { expect(response).to render_template :edit }
      end

      context 'updateに成功する場合' do
        before do
          put :update, params: { id: article.id, article: parameters }
        end

        it { expect(assigns[:article].title).to   eq parameters[:title] }
        it { expect(assigns[:article].content).to eq parameters[:content] }
        it { expect(assigns[:article].author).to  eq parameters[:author] }
        it { expect(flash[:notice]).to eq 'Article was successfully updated.' }
        it { expect(response).to redirect_to assigns[:article] }
      end
    end
  end

  describe '#destroy' do
    context '存在しない記事を指定する場合' do
      subject { proc { get :destroy, params: { id: -1 } } }
      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end

    context '存在する記事を指定する場合' do
      before do
        allow_any_instance_of(Article).to receive(:destroy)
        get :destroy, params: { id: article.id }
      end

      it { expect(assigns[:article]).to have_received(:destroy) }
      it { expect(flash[:notice]).to eq 'Article was successfully destroyed.' }
      it { expect(response).to redirect_to articles_url }
    end
  end

  describe '#set_article' do
    context '存在しない記事を指定する場合' do
      before { allow(controller).to receive(:params).and_return(id: -1) }
      subject { proc { controller.send(:set_article) } }
      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end

    context '存在する記事を指定する場合' do
      before do
        allow(controller).to receive(:params).and_return(id: article.id)
        controller.send(:set_article)
      end

      it { expect(assigns[:article]).to eq article }
    end
  end

  describe '#article_params' do
    let(:parameters) do
      {
        title:   article.title,
        content: article.content,
        author:  article.author
      }
    end

    context '許可されたパラメータのみの場合' do
      before { post :create, params: { article: parameters } }
      subject { controller.send(:article_params) }
      it { is_expected.to eq parameters.stringify_keys }
    end

    context '許可されていないパラメータを含む場合' do
      before do
        danger_parameters = parameters.clone
        danger_parameters[:not_permit] = 'not_permit_parameter'
        post :create, params: { article: danger_parameters }
      end

      subject { controller.send(:article_params) }
      it { is_expected.to eq parameters.stringify_keys }
    end
  end
end
