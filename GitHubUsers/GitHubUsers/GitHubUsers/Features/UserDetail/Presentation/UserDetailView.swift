//
//  UserDetailView.swift
//  GitHubUsers
//
//

import SwiftUI

struct UserDetailView: View {
  @EnvironmentObject private var router: Router
  @StateObject var viewModel: UserDetailViewModel
  private let loginUsername: String

  init(loginUsername: String, viewModel: UserDetailViewModel) {
    self.loginUsername = loginUsername
    _viewModel = .init(wrappedValue: viewModel)
  }

  var body: some View {
    VStack {
      if let errorMessage = viewModel.errorMessage {
        Text(errorMessage)
          .foregroundColor(.red)
          .padding()
      }

      if viewModel.isLoading {
        ProgressView("Loading...")
          .padding()
      } else if let userDetail = viewModel.userDetail {
        VStack(alignment: .leading) {
          HStack {
            AsyncImage(url: URL(string: userDetail.avatarUrl)) { image in
              image.resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .cornerRadius(50)
            } placeholder: {
              ProgressView()
                .frame(width: 80, height: 80)
            }
            .padding(.trailing, 16)
            VStack(alignment: .leading) {
              Text(userDetail.login)
                .font(.headline)
              Rectangle()
                .fill(.gray.opacity(0.1))
                .frame(height: 1)
                .padding(.vertical, 4)
              Text(userDetail.location)
            }
          }
          VStack(alignment: .center) {
            Button(action: {
              // Action for follow button
            }) {
              Text("Follow")
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.gray) // Use different colors for follow/following
                .cornerRadius(8)
            }

            Button(action: {
              // Action for following button
            }) {
              Text("Following")
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue) // You can customize this color
                .cornerRadius(8)
            }
          }
          Spacer()
          //          Text("Username: \(userDetail.login)")
          //          Text("Location: \(userDetail.location)")
          //          Text("Followers: \(userDetail.followers)")
          //          Text("Following: ?")
        }
        .padding()
      }
    }
    .onAppear {
      Task {
        await viewModel.fetchUserDetail(loginUsername: loginUsername)
      }
    }
    .navigationTitle("User Detail")
  }
}
