//
//  UserListView.swift
//  GitHubUsers
//
//

import SwiftUI

struct UserListView: View {
  @EnvironmentObject private var router: Router
  @StateObject var viewModel: UserListViewModel

  let perPage = 20
  @State private var page = 0

  var body: some View {
    NavigationView {
      VStack {
        if viewModel.isLoading && viewModel.users.isEmpty {
          ProgressView("Loading...")
        }

        List(viewModel.users, id: \.id) { user in
          Button(action: {
            router.navigate(to: UserDestination.userDetail(user.login))
          })
          {
            HStack {
              AsyncImage(url: URL(string: user.avatarUrl)) { image in
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
                Text(user.login)
                  .font(.headline)
                Rectangle()
                  .fill(.gray.opacity(0.1))
                  .frame(height: 1)
                  .padding(.vertical, 4)
                if let url = URL(string: user.htmlUrl) {
                  Link(destination: url) {
                    Text(user.htmlUrl)
                      .font(.subheadline)
                      .foregroundColor(.blue)
                  }
                }
              }
            }
          }
          .onAppear {
            viewModel.loadMoreIfNeeded(for: user)
          }
        }
        .navigationTitle("GitHub Users")
        .onAppear {
          Task {
            await viewModel.loadUsers()
          }
        }
      }
    }
  }
}
