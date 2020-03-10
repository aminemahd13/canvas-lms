#
# Copyright (C) 2020 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

module Lti
  class AccountLookupController < ApplicationController
    include Ims::Concerns::AdvantageServices
    include Api::V1::Account

    MIME_TYPE = 'application/vnd.canvas.accountlookup+json'.freeze

    def show
      # sending read_only=true; sending false would give more fields but passes the
      # nil session in to extensions' extend_account_json() which may not be safe
      render json: account_json(context, nil, nil, [], true), content_type: MIME_TYPE
    end

    private

    def scopes_matcher
      self.class.all_of(TokenScopes::LTI_ACCOUNT_LOOKUP_SCOPE)
    end

    def context
      # This can also find accounts in other shards if passed a global ID.
      # verify_active_in_account (via DeveloperKey#account_binding_for) prevents us from
      # accessing accounts we shouldn't, including in different shards from the dev key
      @context ||= Account.find(params[:account_id])
    end

    def verify_tool
      # no-op. not necessary to check for a tool associated with the account for this endpoint
    end
  end
end
