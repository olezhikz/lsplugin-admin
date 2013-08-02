<?php
/**
 * LiveStreet CMS
 * Copyright © 2013 OOO "ЛС-СОФТ"
 * 
 * ------------------------------------------------------
 * 
 * Official site: www.livestreetcms.com
 * Contact e-mail: office@livestreetcms.com
 * 
 * GNU General Public License, version 2:
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 * 
 * ------------------------------------------------------
 * 
 * @link http://www.livestreetcms.com
 * @copyright 2013 OOO "ЛС-СОФТ"
 * @author PSNet <light.feel@gmail.com>
 * 
 */

class PluginAdmin_ModuleUsers extends Module {

	protected $oMapper = null;

	/*
	 * корректные значения для сортировок пользователей
	 */
	protected $aCorrectSortingOrder = array(
		'u.user_id',
		'u.user_login',
		'u.user_date_register',
		'u.user_rating',
		'u.user_skill',
		'u.user_profile_name',
		'u.user_profile_birthday',
		's.session_ip_last',
	);

	/*
	 * сортировка пользователей по-умолчанию
	 */
	protected $sSortingOrderByDefault = 'u.user_id desc';

	/*
	 * корректные направления сортировки
	 */
	protected $SortingOrderWays = array('asc', 'desc');



	public function Init() {
		$this->oMapper = Engine::GetMapper(__CLASS__);
	}


	/**
	 * Возвращает список пользователей по фильтру
	 *
	 * @param array $aFilter	Фильтр
	 * @param array $aOrder	Сортировка
	 * @param int $iCurrPage	Номер страницы
	 * @param int $iPerPage	Количество элментов на страницу
	 * @param array $aAllowData	Список типо данных для подгрузки к пользователям
	 * @return array('collection'=>array,'count'=>int)
	 */
	public function GetUsersByFilter($aFilter = array(), $aOrder = array(), $iCurrPage = 1, $iPerPage = PHP_INT_MAX, $aAllowData = null) {
		if (is_null ($aAllowData)) {
			$aAllowData = array ('session');
		}
		$iCount = 0;
		$sOrder = $this -> GetCorrectSortingOrder($aOrder);
		$aUsersIds = $this -> oMapper -> GetUsersByFilter($aFilter, $sOrder, $iCount, $iCurrPage, $iPerPage);

		$mData = array(
			'collection' => $aUsersIds,
			'count' => $iCount
		);
		$mData['collection'] = $this -> User_GetUsersAdditionalData($mData['collection'], $aAllowData);
		return $mData;
	}


	/**
	 * Проверяет корректность сортировки и возращает часть sql запроса для сортировки
	 *
	 * @param array $aOrder		поля по которым нужно сортировать вывод пользователей
	 * 							example: array('login' => 'desc', 'rating' => 'desc')
	 * @return string			часть sql запроса
	 */
	protected function GetCorrectSortingOrder($aOrder = array ()) {
		$sOrder = '';
		foreach($aOrder as $sRow => $sDir) {
			if (!in_array($sRow, $this -> aCorrectSortingOrder)) {
				unset($aOrder[$sRow]);
			} elseif (in_array($sDir, $this -> SortingOrderWays)) {
				$sOrder .= " {$sRow} {$sDir},";
			}
		}
		$sOrder = rtrim($sOrder, ',');
		if (empty($sOrder)) {
			$sOrder = $this -> sSortingOrderByDefault;
		}
		return $sOrder;
	}


	public function GetReversedOrderDirection ($sWay){
		if (!in_array($sWay, $this -> SortingOrderWays)) return 'desc';
		return $this -> SortingOrderWays[(int) ($sWay == 'asc')];
	}
	
}

?>