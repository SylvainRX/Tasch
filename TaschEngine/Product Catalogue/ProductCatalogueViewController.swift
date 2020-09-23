import Resolver
import Tasch
import UIKit

class ProductCatalogueViewController: UIViewController {

  class func make() -> ProductCatalogueViewController {
    let viewController = ProductCatalogueViewController()
    let dataLayer: Tasch.DataLayer = Resolver.resolve()
    let router = ProductCatalogueRouterImp(productCatalogueViewController: viewController)
    let useCase = Tasch.ProductCatalogueUseCaseImp(dataLayer: dataLayer)
    let presenter = ProductCataloguePresenter(router: router, useCase: useCase)
    presenter.view = viewController
    viewController.presenter = presenter
    return viewController
  }

  private var colorTheme: ColorTheme = Resolver.resolve()
  private var presenter: ProductCataloguePresenter!
  private var state: ProductCatalogue.ViewState = .loading {
    didSet { updateForCurrentState() }
  }

  private var models: [ProductCatalogue.Model] {
    guard case let .productCatalogue(models) = state else { return [] }
    return models
  }

  private var loadingView: UIView?
  private var errorView: UIView?
  private var collectionView: UICollectionView!

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpView()
    updateForCurrentState()
  }

  private func setUpView() {
    view.backgroundColor = colorTheme.firstLevelBackground
    setUpCollectionView()
  }

  private func setUpCollectionView() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.addFillerSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceHorizontal = true
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(ProductCatalogueCell.self, forCellWithReuseIdentifier: ProductCatalogueCell.identifier)
    collectionView.showsHorizontalScrollIndicator = false

    self.collectionView = collectionView
  }

  private func updateForCurrentState() {
    guard isViewLoaded else { return }
    showNeutralState()
    switch state {
    case .loading:
      showLoading()
    case .productCatalogue:
      updateProductCatalogueView()
    case let .error(error):
      showError(error)
    }
  }

  private func showNeutralState() {
    hideLoading()
    hideError()
  }

  private func showLoading() {
    loadingView = LoadingView.make()
    view.addFillerSubview(loadingView!)
  }

  private func hideLoading() {
    loadingView?.removeFromSuperview()
    loadingView = nil
  }

  private func updateProductCatalogueView() {
    collectionView.reloadData()
  }

  private func showError(_ error: ErrorDescription) {
    let localization: Localization = Resolver.resolve()
    let messageView = MessageView.make(message: "\(error.title):\n\(error.message)",
                                       actionTitle: localization.for("product_catalogue.error.reload.action"),
                                       action: { [weak self] in self?.presenter.refreshCatalogue() })
    view.addFillerSubview(messageView, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    errorView = messageView
  }

  private func hideError() {
    errorView?.removeFromSuperview()
    errorView = nil
  }
}

// MARK: - UICollectionViewDataSource
extension ProductCatalogueViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return models.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCatalogueCell.identifier, for: indexPath) as! ProductCatalogueCell
    let model = models.indices.contains(indexPath.row) ? models[indexPath.row] : nil
    cell.model = model
    return cell
  }
}

//// MARK: - UICollectionViewDelegate
extension ProductCatalogueViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let model = models.indices.contains(indexPath.row) ? models[indexPath.row] : nil else { return }
    presenter.showDetailForProduct(withId: model.id)
  }
}

// MARK: - UICollectionViewDelegate
extension ProductCatalogueViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let viewHeight = view.frame.height
    return CGSize(width: viewHeight, height: viewHeight)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
  }
}

// MARK: - ProductCatalogueView
extension ProductCatalogueViewController: ProductCatalogueView {

  func updateState(_ state: ProductCatalogue.ViewState) {
    self.state = state
  }
}
