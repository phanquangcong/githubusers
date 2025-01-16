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
        VStack(alignment: .leading, spacing: 16) {
          HStack {
            AsyncImage(url: URL(string: userDetail.avatarUrl)) { image in
              image.resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .cornerRadius(40)
            } placeholder: {
              ProgressView()
                .frame(width: 80, height: 80)
            }
            .padding(.trailing, 16)

            VStack(alignment: .leading) {
              Text(userDetail.login)
                .font(.headline)
                .padding(.bottom, 2)
              Text(userDetail.location)
                .font(.subheadline)
                .foregroundColor(.gray)
            }
          }
          .shadow(radius: 10, x: 0, y: 5)

          Rectangle()
            .fill(Color.gray.opacity(0.1))
            .frame(height: 1)
            .padding(.vertical, 8)

          HStack(spacing: 30) {
            VStack {
              Image("icon_followers")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
              Text("\(userDetail.followers) Followers")
                .font(.subheadline)
            }
            VStack {
              Image("icon_following")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
              Text("\(userDetail.following) Following")
                .font(.subheadline)
            }
          }
          .frame(maxWidth: .infinity, alignment: .center)

          Rectangle()
            .fill(Color.gray.opacity(0.1))
            .frame(height: 1)
            .padding(.vertical, 8)

          if let blogUrl = URL(string: userDetail.htmlUrl) {
            VStack(alignment: .leading) {
              Text("Blog")
                .font(.headline)
                .padding(.bottom, 2)
              Link(destination: blogUrl) {
                Text(userDetail.htmlUrl)
                  .font(.subheadline)
                  .foregroundColor(.blue)
              }
            }
          }

          Spacer()
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
