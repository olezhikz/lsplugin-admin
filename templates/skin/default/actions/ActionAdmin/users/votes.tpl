{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_content'}

	<h2 class="title mb-20">
		{$aLang.plugin.admin.users.votes.title}
	</h2>

	<div class="mb-20"><a href="{router page="admin/users/profile/{$oUser->getId()}"}">{$aLang.plugin.admin.users.votes.back_to_user_profile_page} {$oUser->getLogin()}</a></div>

	<div class="mb-20">
		{$aLang.plugin.admin.users.votes.votes_for}
		{$aLang.plugin.admin.users.votes.votes_type.$sVotingTargetType}
	</div>

	{if aVotingList and count($aVotingList)>0}

		<table class="table">
			<thead>
				<tr>
					{include file="{$aTemplatePathPlugin.admin}actions/ActionAdmin/users/sorting_cell.tpl"
						sCellClassName='targetid'
						mSortingOrder='target_id'
						mLinkHtml=$aLang.plugin.admin.users.votes.table_header.target_id
						sBaseUrl="{router page="admin/users/votes/{$oUser->getId()}"}"
					}
					{include file="{$aTemplatePathPlugin.admin}actions/ActionAdmin/users/sorting_cell.tpl"
						sCellClassName='vote_direction'
						mSortingOrder='vote_direction'
						mLinkHtml=$aLang.plugin.admin.users.votes.table_header.vote_direction
						sBaseUrl="{router page="admin/users/votes/{$oUser->getId()}"}"
					}
					{include file="{$aTemplatePathPlugin.admin}actions/ActionAdmin/users/sorting_cell.tpl"
						sCellClassName='vote_value'
						mSortingOrder='vote_value'
						mLinkHtml=$aLang.plugin.admin.users.votes.table_header.vote_value
						sBaseUrl="{router page="admin/users/votes/{$oUser->getId()}"}"
					}
					{include file="{$aTemplatePathPlugin.admin}actions/ActionAdmin/users/sorting_cell.tpl"
						sCellClassName='vote_date'
						mSortingOrder='vote_date'
						mLinkHtml=$aLang.plugin.admin.users.votes.table_header.vote_date
						sBaseUrl="{router page="admin/users/votes/{$oUser->getId()}"}"
					}
					{include file="{$aTemplatePathPlugin.admin}actions/ActionAdmin/users/sorting_cell.tpl"
						sCellClassName='vote_ip'
						mSortingOrder='vote_ip'
						mLinkHtml=$aLang.plugin.admin.users.votes.table_header.vote_ip
						sBaseUrl="{router page="admin/users/votes/{$oUser->getId()}"}"
					}
					<th>
						{$aLang.plugin.admin.users.votes.table_header.target_object}
					</th>
				</tr>
			</thead>
			<tbody>
				{foreach from=$aVotingList item="oVote"}
					<tr>
						<td>
							{$oVote->getTargetId()}
						</td>
						<td>
							{$oVote->getDirection()}
						</td>
						<td>
							{$oVote->getValue()}
						</td>
						<td>
							{$oVote->getDate()}
						</td>
						<td>
							{$oVote->getIp()}
						</td>
						<td>
							<a href="{$oVote->getTargetFullUrl()}"
							   target="_blank"
							   title="{$oVote->getTargetTitle()|escape:'html'}">{$oVote->getTargetTitle()|truncate:100:'...'}</a>
						</td>
					</tr>
				{/foreach}
			</tbody>
		</table>
	{else}
		{$aLang.plugin.admin.users.votes.no_votes}
	{/if}

	{include file="{$aTemplatePathPlugin.admin}forms/elements_on_page.tpl"
		sFormActionPath="{router page='admin/votes/ajax-on-page'}"
		sFormId = 'admin_votes_onpage'
		iCurrentValue = $oConfig->GetValue('plugin.admin.votes.per_page')
	}

	{include file="{$aTemplatePathPlugin.admin}pagination.tpl" aPaging=$aPaging}

{/block}