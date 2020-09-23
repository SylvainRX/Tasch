import Resolver
import UIKit

class MessageView: UIView {

  class func make(message: String,
                  actionTitle: String,
                  action: @escaping () -> Void) -> MessageView {
    let view = MessageView()
    view.message = message
    view.actionTitle = actionTitle
    view.action = action
    view.setUp()
    return view
  }

  private var message: String!
  private var actionTitle: String!
  private var action: (() -> Void)!

  private func setUp() {
    applyViewStyle(.card)
    layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

    let containerView = UIView()
    addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.leftAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leftAnchor),
      containerView.rightAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.rightAnchor),
      containerView.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor),
      containerView.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
      containerView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
    ])

    let messageLabel = UILabel()
    messageLabel.applyLabelStyle(.default)
    messageLabel.text = message
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 0
    messageLabel.lineBreakMode = .byWordWrapping
    containerView.addSubview(messageLabel)
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
      messageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
      messageLabel.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor),
      messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
    ])

    let button = UIButton(type: .custom)
    button.applyButtonStyle(.default)
    button.setTitle(actionTitle, for: .normal)
    button.addTarget(self, action: #selector(doAction), for: .primaryActionTriggered)
    containerView.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.leftAnchor.constraint(greaterThanOrEqualTo: containerView.leftAnchor),
      button.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor),
      button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
      button.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
      button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
    ])
  }

  @objc func doAction() {
    action()
  }
}
