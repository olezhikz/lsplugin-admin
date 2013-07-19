<?php
/*-------------------------------------------------------
*
*   LiveStreet Engine Social Networking
*   Copyright © 2008 Mzhelskiy Maxim
*
*--------------------------------------------------------
*
*   Official site: www.livestreet.ru
*   Contact e-mail: rus.engine@gmail.com
*
*   GNU General Public License, version 2:
*   http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
*
---------------------------------------------------------
*/

class PluginAdmin_ActionAdmin extends ActionPlugin {
	
	// Списки групп настроек системного конфига
	protected $aCoreSettingsGroups = array ();
	
	// Имя виртуального метода, который будет пойман в __call для групп системных настроек
	protected $sCallbackMethodToShowSystemSettings = 'EventShowSystemSettings';
	

	public function Init () {
		// Reset added styles and scripts
		$this -> Viewer_ClearStyle (true);
		
		$sFrameworkPath = Config::Get ('path.static.framework');
		$aPluginTemplatePath = Plugin::GetTemplatePath (__CLASS__);
		
		$aStyles = array(
			$sFrameworkPath . "/css/reset.css",
			$sFrameworkPath . "/css/helpers.css",
			$sFrameworkPath . "/css/text.css",
			$sFrameworkPath . "/css/dropdowns.css",
			$sFrameworkPath . "/css/buttons.css",
			$sFrameworkPath . "/css/forms.css",
			$sFrameworkPath . "/css/navs.css",
			$sFrameworkPath . "/css/modals.css",
			$sFrameworkPath . "/css/tooltip.css",
			$sFrameworkPath . "/css/popover.css",
			$sFrameworkPath . "/css/alerts.css",
			$sFrameworkPath . "/css/toolbar.css",
			
			$aPluginTemplatePath . "css/base.css",
			$aPluginTemplatePath . "css/grid.css",
			$aPluginTemplatePath . "css/blocks.css",
			$aPluginTemplatePath . "css/pagination.css",
			$aPluginTemplatePath . "css/icons.css",
			$aPluginTemplatePath . "css/navs.css",
			$aPluginTemplatePath . "css/__temp__.css", // todo: temporary, delete on production
		);
		
		$aScripts = array(
			$sFrameworkPath . "/js/vendor/jquery-1.9.1.min.js",
			$sFrameworkPath . "/js/vendor/jquery-ui/js/jquery-ui-1.10.2.custom.min.js",
			$sFrameworkPath . "/js/vendor/jquery-ui/js/localization/jquery-ui-datepicker-ru.js",
			$sFrameworkPath . "/js/vendor/jquery.browser.js",
			$sFrameworkPath . "/js/vendor/jquery.scrollto.js",
			$sFrameworkPath . "/js/vendor/jquery.rich-array.min.js",
			$sFrameworkPath . "/js/vendor/jquery.form.js",
			$sFrameworkPath . "/js/vendor/jquery.jqplugin.js",
			$sFrameworkPath . "/js/vendor/jquery.cookie.js",
			$sFrameworkPath . "/js/vendor/jquery.serializejson.js",
			$sFrameworkPath . "/js/vendor/jquery.file.js",
			$sFrameworkPath . "/js/vendor/jcrop/jquery.Jcrop.js",
			$sFrameworkPath . "/js/vendor/jquery.placeholder.min.js",
			$sFrameworkPath . "/js/vendor/jquery.charcount.js",
			$sFrameworkPath . "/js/vendor/jquery.imagesloaded.js",
			$sFrameworkPath . "/js/vendor/notifier/jquery.notifier.js",
			$sFrameworkPath . "/js/vendor/markitup/jquery.markitup.js",
			$sFrameworkPath . "/js/vendor/prettify/prettify.js",
			$sFrameworkPath . "/js/vendor/prettyphoto/js/jquery.prettyphoto.js",

			$sFrameworkPath . "/js/core/hook.js",
			$sFrameworkPath . "/js/core/main.js",

			$sFrameworkPath . "/js/ui/popup.js",
			$sFrameworkPath . "/js/ui/dropdown.js",
			$sFrameworkPath . "/js/ui/tooltip.js",
			$sFrameworkPath . "/js/ui/popover.js",
			$sFrameworkPath . "/js/ui/tab.js",
			$sFrameworkPath . "/js/ui/modal.js",
			$sFrameworkPath . "/js/ui/toolbar.js",

			$sFrameworkPath . "/js/livestreet/init.js",
			
			$aPluginTemplatePath . "/js/init.js",
		);
		
		array_map (array ($this, 'Viewer_AppendStyle'), $aStyles);
		array_map (array ($this, 'Viewer_AppendScript'), $aScripts);
		
		$this -> aCoreSettingsGroups = Config::Get ('plugin.admin.core_config_groups');
		
		$this -> SetDefaultEvent ('index');
		$this -> Hook_Run ('init_action_admin');
		$this -> Viewer_AddHtmlTitle ($this -> Lang_Get ('plugin.admin.title'));
	}


	/**
	 * Регистрируем евенты
	 */
	protected function RegisterEvent () {
		/**
		 * Регистрируем внешние обработчики евентов
		 */
		$this -> RegisterEventExternal('User','PluginAdmin_ActionAdmin_EventUser');
		$this -> RegisterEventExternal('Plugin','PluginAdmin_ActionAdmin_EventPlugin');
		$this -> RegisterEventExternal('Plugins', 'PluginAdmin_ActionAdmin_EventPlugins');					// Список плагинов
		$this -> RegisterEventExternal('Settings', 'PluginAdmin_ActionAdmin_EventSettings');				// Работа с настройками плагинов
		
		//
		// дашборд и статистика
		//
		$this -> AddEvent('index', 'EventIndex');
		
		//
		// Пользователи
		//
		$this -> AddEventPreg ('/^user$/i', '/^list$/i','/^$/i', 'User::EventUserList');
		
		//
		// Плагины
		//
		$this -> AddEventPreg ('/^plugin$/i', '/^[\w_\-]+$/i', 'Plugin::EventPlugin');			      // показать страницу собственных настроек плагина
		$this -> AddEventPreg ('#^plugins$#iu', '#^list$#iu', 'Plugins::EventPluginsList');  		// список плагинов
		
		//
		// Настройки
		//
		$this -> AddEventPreg ('#^settings$#iu', '#^plugin$#iu', 'Settings::EventShow');         // настройки плагина
		$this -> AddEventPreg ('#^settings$#iu', '#^save$#iu', 'Settings::EventSaveConfig');     // сохранить настройки
		
		//
		// Системные настройки
		//
		// для каждой группы настроек добавим виртуальный эвент и будем ловить их через __call()
		// чтобы не плодить полупустых методов, так компактнее и удобнее
		// todo: нужно что-то ещё с меню придумать чтобы полностью автоматизировать процесс создания групп
		// пока в меню нужно прописывать вручную пунткы групп
		foreach (array_keys (Config::Get ('plugin.admin.core_config_groups')) as $sKey) {
			$this -> AddEventPreg ('#^settings$#iu', '#^' . $sKey . '$#iu', 'Settings::' . $this -> sCallbackMethodToShowSystemSettings . $sKey);
		}
	}


	/**********************************************************************************
	 ************************ РЕАЛИЗАЦИЯ ЭКШЕНА ***************************************
	 **********************************************************************************
	 */

	protected function EventIndex () {
		// дашборд
		$this -> SetTemplateAction('index');
	}
	
	
	// Построение меню
	private function InitMenu () {
		$this -> PluginAdmin_Ui_GetMenuMain()
			->AddSection(
				Engine::GetEntity('PluginAdmin_Ui_MenuSection')->SetCaption('Главная')->SetUrl('')
			)	// /AddSection
			->AddSection(
				Engine::GetEntity('PluginAdmin_Ui_MenuSection')->SetCaption('Пользователи')->SetName('user')->SetUrl('user')
				
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Статистика')->SetUrl('stats'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Весь список')->SetUrl('list'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Бан-листы')->SetUrl('ban'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Администраторы')->SetUrl('admins'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Инвайты')->SetUrl('invite'))
			)	// /AddSection
			->AddSection(
				Engine::GetEntity('PluginAdmin_Ui_MenuSection')->SetCaption('Плагины')->SetName('settings')->SetUrl('plugins')
				
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Список плагинов')->SetUrl('list'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Установить плагин')->SetUrl('install'))
			)	// /AddSection
			->AddSection(
				Engine::GetEntity('PluginAdmin_Ui_MenuSection')->SetCaption('Настройки')->SetName('settings')->SetUrl('settings')
				
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Внешний вид сайта')->SetUrl('view'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Интерфейс')->SetUrl('interface'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Системные')->SetUrl('system'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Почта')->SetUrl('sysmail'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('ACL создания')->SetUrl('aclcreate'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('ACL голосования')->SetUrl('aclvote'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Модуль блогов')->SetUrl('moduleblog'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Модуль топиков')->SetUrl('moduletopic'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Модуль пользователей')->SetUrl('moduleuser'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Модуль комментариев')->SetUrl('modulecomment'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Модуль писем')->SetUrl('moduletalk'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Модуль уведомлений')->SetUrl('modulenotify'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Модуль изображений')->SetUrl('moduleimage'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Модуль стены')->SetUrl('modulewall'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Модули разные')->SetUrl('moduleother'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Таблицы БД')->SetUrl('db'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Правила блоков')->SetUrl('blocksrule'))
				->AddItem(Engine::GetEntity('PluginAdmin_Ui_MenuItem')->SetCaption('Обработка JS и CSS')->SetUrl('compress'))
			)	// /AddSection
		;
	}
	
	
	public function EventShutdown () {
		$this -> Viewer_Assign('oMenuMain', $this -> PluginAdmin_Ui_GetMenuMain());
		$this -> Viewer_Assign('oMenuAddition', $this -> PluginAdmin_Ui_GetMenuAddition());

		$this -> InitMenu();	// todo: review: dublicates menu when redirecting using router
		$this -> Viewer_AddBlock('right','blocks/block.nav.tpl',array('plugin'=>'admin'));

		$this -> PluginAdmin_Ui_HighlightMenus();
		
		// для редактирования настроек плагинов и системы
		$this -> Viewer_Assign ('sAdminSettingsFormSystemId', PluginAdmin_ModuleSettings::ADMIN_SETTINGS_FORM_SYSTEM_ID);
		$this -> Viewer_Assign ('sAdminSystemConfigId', ModuleStorage::DEFAULT_KEY_NAME);
	}
	
}

?>