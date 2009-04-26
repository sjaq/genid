<?php 

	class GenID {
		
		// array of usable characters, mix them together to get more random results
		// you can add uppercase chars to increase the number of possibilities
		private $useChars = array(
		 	1 => 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
			'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
			't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2',
			'3', '4', '5', '6', '7', '8', '9'
		);
		
		// reserved id's with the id that generates it as key
		private $reserved = array(
			'iphone' => 1841035906
		);
		
		private $linkCCount;
		private static $instance;
		
		private function __clone() {}
		
		public static function get($id, $force = null) {
			if(self::$instance === null) {
				self::$instance = new GenID;
			}
			return self::$instance->run($id, $force);
		}
		
		private function run($id, $force = null) {
			if(is_string($id) || $force == 'string') {
				return $this->strtoid($id);
			} else {
				$id = intval($id);
				return $this->idtostr($id);
			}
		}
		
		private function fixId($id) {
			if(in_array($id, $this->reserved)) {
				$nid = $id+1;
				return $this->fixId($nid);
			} else {
				return (int)$id;
			}
		}
		
		private function clean($url) {
			return preg_replace('/([\W\s])/', '', $url);
		}
		
		private function idtostr($id, $nofix = false) {
			if(!isset($this->linkCCount)) {
				$this->linkCCount = count($this->useChars);
			}
			$this->link = '';
			$this->idtostrsub($id);
			return strrev($this->link);
		}
		
		private function strtoid($str) {
			if(!isset($this->linkCCount)) {
				$this->linkCCount = count($this->useChars);
			}
			$str = strtolower($str);
			$str = $this->clean($str);
			if(strlen($str) === 0) {
				return false;
			} elseif(strlen($str) === 1) {
				return array_search($str, $this->useChars);
			}
			$chars = array();
			foreach(str_split($str) as $k => $v) {
				if(in_array($v, $this->useChars)) {
					$chars[] = array_search($v, $this->useChars);
				}
			}
			$s = $chars[0];
			unset($chars[0]);
			// start the math

			foreach($chars as $char) {
				$s = ($s * $this->linkCCount) + $char;
			}

			return $s;
		}

		private function idtostrsub($id) {
			// if the id is smaller then the amount of chars just give it a char
			$c = $this->linkCCount;
			
			if($id < $c && $id >= 0) {
				$this->link .= $this->useChars[$id];
			} else {
				// devide the id by the amount of chars
				$flr = floor($id / $c);
				$res = $id+1 - ($flr * $c);
				$this->link .= $this->useChars[$res];
				$this->link .= ($flr <= $c && $flr >= 0)? 
				/* true */	$this->useChars[$flr] :
				/* false */	$this->idtostrsub($flr);
			}
		}
		
	}

?>