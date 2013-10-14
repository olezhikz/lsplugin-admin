{**
 * Страница пользователя
 *}

{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}


{* Actionbar *}
{block name='layout_content_actionbar_class'}actionbar-user{/block}
{block name='layout_content_actionbar'}
	<ul>
		<li><a href="#"><i class="icon-white icon-pencil"></i></a></li>

		{include file="{$aTemplatePathPlugin.admin}actions/ActionAdmin/users/user_operations.tpl"}

		<li class="fl-r"><a href="#"><i class="icon-white icon-chevron-right"></i></a></li>
		<li class="fl-r"><a href="#"><i class="icon-white icon-chevron-left"></i></a></li>
	</ul>
{/block}


{* User menu *}
{block name='layout_content_before'}
	<header class="user-header">
		<div class="user-brief clearfix">
			<div class="user-brief-body">
				<a href="{$oUser->getUserWebPath()}" class="user-avatar {if $oUser->isOnline()}user-is-online{/if}">
					<img src="{$oUser->getProfileAvatarPath(100)}" 
						 alt="avatar" 
						 title="{if $oUser->isOnline()}{$aLang.user_status_online}{else}{$aLang.user_status_offline}{/if}" />
				</a>

				<h3 class="user-login">
					{$oUser->getLogin()}

					{if $oUser->isAdministrator()}
						<i class="icon-user-admin" title="Admin"></i>
					{/if}
				</h3>

				{if $oUser->getProfileName()}
					<p class="user-name">{$oUser->getProfileName()}</p>
				{/if}

				<p class="user-mail"><a href="mailto:{$oUser->getMail()}" class="link-border"><span>{$oUser->getMail()}</span></a></p>

				<p class="user-id">{$aLang.plugin.admin.users.profile.user_no}{$oUser->getId()}</p>
			</div>

			{**
			 * Редактирование рейтинга
			 *}
			<div class="user-brief-aside">
				<form action="{router page='admin/users/ajax-edit-rating'}" method="post" enctype="application/x-www-form-urlencoded" id="admin_editrating">
					<input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" />
					<input type="hidden" name="user_id" value="{$oUser->getId()}" />

					<i class="icon-rating" title="{$aLang.plugin.admin.users.profile.rating}"></i>
					<input type="text" name="user-rating" class="input-text width-50" value="{$oUser->getRating()}" title="{$aLang.plugin.admin.users.profile.rating}" />

					<button type="submit" name="submit_edit_rating" class="button">{$aLang.plugin.admin.save}</button>
				</form>
			</div>
		</div>
	</header>
{/block}


{block name='layout_content'}
	{$oSession = $oUser->getSession()}

	<aside class="user-info-aside">
		<div class="block block-user-photo">
			<a href="{$oUser->getUserWebPath()}"><img src="{$oUser->getProfileFotoPath()}" alt="" class="photo" /></a>
		</div>

		{include file="blocks/block.userNote.tpl" oUserProfile=$oUser oUserNote=$oUser->getUserNote()}

		<div class="block block-user-menu">
			<ul class="user-menu">
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.profile}</span></a></li>
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}created/" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.publications}</span></a></li>
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}stream/" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.activity}</span></a></li>
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}friends/" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.friends}</span></a></li>
				{*<li class="user-menu-item"><a href="#" class="link-border"><span>Жалобы</span></a></li>*}
				{*<li class="user-menu-item"><a href="#" class="link-border"><span>Счет</span></a></li>*}
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}wall/" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.wall}</span></a></li>
				{*<li class="user-menu-item"><a href="#" class="link-border"><span>Блоги</span></a></li>*}
				<li class="user-menu-item"><a href="{$oUser->getUserWebPath()}favourites/" class="link-border"><span>{$aLang.plugin.admin.users.profile.middle_bar.fav}</span></a></li>
				{*<li class="user-menu-item"><a href="#" class="link-border"><span>Почта</span></a></li>*}
				{*<li class="user-menu-item"><a href="#" class="link-border"><span>Права</span></a></li>*}
			</ul>
		</div>
	</aside>


	<div class="user-info-body">
		{* Basic info *}
		<div class="user-info-block user-info-block-resume">
			<h2 class="user-info-heading">{$aLang.plugin.admin.users.profile.info.resume}</h2>

			<dl class="dotted-list-item">
				<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.mail}</dt>
				<dd class="dotted-list-item-value">
					<a href="{router page='admin/users/list'}{request_filter
						name=array('mail')
						value=array($oUser->getMail())
					}">{$oUser->getMail()}</a>
				</dd>
			</dl>
			{if $oUser->getProfileSex() != 'other'}
				<dl class="dotted-list-item">
					<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.sex}</dt>
					<dd class="dotted-list-item-value">
						{if $oUser->getProfileSex() == 'man'}
							{$aLang.profile_sex_man}
						{else}
							{$aLang.profile_sex_woman}
						{/if}
					</dd>
				</dl>
			{/if}
			{if $oUser->getProfileBirthday()}
				<dl class="dotted-list-item">
					<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.birthday}</dt>
					<dd class="dotted-list-item-value">{date_format date=$oUser->getProfileBirthday() format="j F Y" notz=true}</dd>
				</dl>
			{/if}

			{if $oGeoTarget}
				<dl class="dotted-list-item">
					<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.living}</dt>
					<dd class="dotted-list-item-value">
						{if $oGeoTarget->getCountryId()}
							<a href="{router page='people/country'}{$oGeoTarget->getCountryId()}/">{$oUser->getProfileCountry()|escape:'html'}</a>{if $oGeoTarget->getCityId()},{/if}
						{/if}

						{if $oGeoTarget->getCityId()}
							<a href="{router page='people/city'}{$oGeoTarget->getCityId()}/">{$oUser->getProfileCity()|escape:'html'}</a>
						{/if}
					</dd>
				</dl>
			{/if}

			<dl class="dotted-list-item mt-20">
				<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.reg_date}</dt>
				<dd class="dotted-list-item-value">{date_format date=$oUser->getDateRegister()}</dd>
			</dl>
			<dl class="dotted-list-item">
				<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.ip}</dt>
				<dd class="dotted-list-item-value">
					<a href="{router page='admin/users/list'}{request_filter
						name=array('ip_register')
						value=array($oUser->getIpRegister())
					}">{$oUser->getIpRegister()}</a>
				</dd>
			</dl>

			{if $oSession}
				<dl class="dotted-list-item mt-20">
					<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.last_visit}</dt>
					<dd class="dotted-list-item-value">{date_format date=$oSession->getDateLast()}</dd>
				</dl>
				<dl class="dotted-list-item">
					<dt class="dotted-list-item-label">{$aLang.plugin.admin.users.profile.info.ip}</dt>
					<dd class="dotted-list-item-value">
						<a href="{router page='admin/users/list'}{request_filter
							name=array('session_ip_last')
							value=array($oSession->getIpLast())
						}">{$oSession->getIpLast()}</a>
						<br />
						<a href="{router page='admin/users/list'}{request_filter
							name=array('session_ip_last')
							value=array($oSession->getIpLast())
						}" class="button mt-10">{$aLang.plugin.admin.users.profile.info.search_this_ip}</a>
					</dd>
				</dl>
			{/if}
		</div>

		{* Stats *}
		<div class="user-info-block user-info-block-stats">
			<h2 class="user-info-heading">{$aLang.plugin.admin.users.profile.info.stats_title}</h2>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header">{$aLang.plugin.admin.users.profile.info.created}</div>
				<ul>
					{* todo: fill hrefs in links or leave just a text? *}
					<li><a href="#">{$iCountTopicUser} {$aLang.plugin.admin.users.profile.info.topics}</a></li>
					<li><a href="#">{$iCountCommentUser} {$aLang.plugin.admin.users.profile.info.comments}</a></li>
					<li><a href="#">{$iCountBlogsUser} {$aLang.plugin.admin.users.profile.info.blogs}</a></li>
				</ul>
			</div>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header">{$aLang.plugin.admin.users.profile.info.fav}</div>
				<ul>
					<li><a href="#">{$iCountTopicFavourite} {$aLang.plugin.admin.users.profile.info.topics}</a></li>
					<li><a href="#">{$iCountCommentFavourite} {$aLang.plugin.admin.users.profile.info.comments}</a></li>
				</ul>
			</div>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header">{$aLang.plugin.admin.users.profile.info.reads}</div>
				<ul>
					<li><a href="#">{$iCountBlogReads} {$aLang.plugin.admin.users.profile.info.blogs}</a></li>
				</ul>
			</div>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header">{$aLang.plugin.admin.users.profile.info.has}</div>
				<ul>
					<li><a href="#">{$iCountFriendsUser} {$aLang.plugin.admin.users.profile.info.friends}</a></li>
				</ul>
			</div>
		</div>

		{* Vote stats *}
		<div class="user-info-block user-info-block-stats">
			<h2 class="user-info-heading">{$aLang.plugin.admin.users.profile.info.votings_title}</h2>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header"><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=topic">{$aLang.plugin.admin.users.profile.info.for_topics}</a></div>
				<ul>
					<li><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=topic&filter[dir]=plus">{$aUserVotedStat.topic.plus} +</a></li>
					<li><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=topic&filter[dir]=minus">{$aUserVotedStat.topic.minus} -</a></li>
				</ul>
			</div>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header"><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=comment">{$aLang.plugin.admin.users.profile.info.for_comments}</a></div>
				<ul>
					<li><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=comment&filter[dir]=plus">{$aUserVotedStat.comment.plus} +</a></li>
					<li><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=comment&filter[dir]=minus">{$aUserVotedStat.comment.minus} -</a></li>
				</ul>
			</div>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header"><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=blog">{$aLang.plugin.admin.users.profile.info.for_blogs}</a></div>
				<ul>
					<li><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=blog&filter[dir]=plus">{$aUserVotedStat.blog.plus} +</a></li>
					<li><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=blog&filter[dir]=minus">{$aUserVotedStat.blog.minus} -</a></li>
				</ul>
			</div>

			<div class="user-info-block-stats-row">
				<div class="user-info-block-stats-header"><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=user">{$aLang.plugin.admin.users.profile.info.for_users}</a></div>
				<ul>
					<li><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=user&filter[dir]=plus">{$aUserVotedStat.user.plus} +</a></li>
					<li><a href="{router page="admin/users/votes/{$oUser->getId()}"}?filter[type]=user&filter[dir]=minus">{$aUserVotedStat.user.minus} -</a></li>
				</ul>
			</div>
		</div>

		{* Contacts *}
		<div class="user-info-block user-info-block-contacts">
			<div class="contacts">
				<h2 class="user-info-heading">{$aLang.profile_contacts}</h2>

				{$aUserFieldContactValues = $oUser->getUserFieldValues(true,array('contact'))}

				{if $aUserFieldContactValues}
					<ul class="profile-contact-list">
						{foreach from=$aUserFieldContactValues item=oField}
							<li>
								<i class="icon-contact icon-contact-{$oField->getName()}" title="{$oField->getName()}"></i>
								{$oField->getValue(true,true)}
							</li>
						{/foreach}
					</ul>
				{/if}
			</div>

			<div class="social">
				<h2 class="user-info-heading"> {$aLang.profile_social} </h2>

				{$aUserFieldContactValues = $oUser->getUserFieldValues(true,array('social'))}

				{if $aUserFieldContactValues}
					<ul class="profile-contact-list">
						{foreach from=$aUserFieldContactValues item=oField}
							<li>
								<i class="icon-contact icon-contact-{$oField->getName()}" title="{$oField->getName()}"></i>
								{$oField->getValue(true,true)}
							</li>
						{/foreach}
					</ul>
				{/if}

			</div>
		</div>
	</div>
{/block}