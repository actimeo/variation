<?php
/*
This file is part of Variation.

Variation is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Variation is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with Variation.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------
Ce fichier fait partie de Variation.

Variation est un logiciel libre ; vous pouvez le redistribuer ou le modifier 
suivant les termes de la GNU Affero General Public License telle que publiée 
par la Free Software Foundation ; soit la version 3 de la licence, soit 
(à votre gré) toute version ultérieure.

Variation est distribué dans l'espoir qu'il sera utile, 
mais SANS AUCUNE GARANTIE ; sans même la garantie tacite de 
QUALITÉ MARCHANDE ou d'ADÉQUATION à UN BUT PARTICULIER. Consultez la 
GNU Affero General Public License pour plus de détails.

Vous devez avoir reçu une copie de la GNU Affero General Public License 
en même temps que Variation ; si ce n'est pas le cas, 
consultez <http://www.gnu.org/licenses>.
--------------------------------------------------------------------------------
Copyright (c) 2014 Kavarna SARL
*/
?>
<?php
class Pagination {
  private $base = null;
  private $fct = null;
  private $args = null;
  private $url_file;
  private $url_args;
  private $columns = array ();
  private $ncolumns = 0;
  private $lines = 10;
  private $count = null;
  private $data = null;
  private $imagesPath = null;
  private $defaultColOrder = 1;

  function Pagination ($base) {
    $this->base = $base;
  }

  function setImagesPath ($imagesPath) {
    $this->imagesPath = $imagesPath;
  }

  function setDefaultColOrder ($defaultColOrder) {
    $this->defaultColOrder = $defaultColOrder;
  }

  function setFunction ($function, $args) {
    $this->fct = $function;
    $this->args = $args;
  }

  function setUrl ($url_file, $url_args) {
    $this->url_file = $url_file;
    $this->url_args = $url_args;
  }

  function addColumn ($label, $code = null, $link_function = null, $link_id = null) {
    $this->ncolumns ++;
    $this->columns[$this->ncolumns] = array ($label, $code, $link_function, $link_id);
  }

  function setLines ($lines) {
    $this->lines = $lines;
  }

  function getCount () {
    $args = $this->args;
    $args[] = $this->base->count ();
    $n = $this->base->__call ($this->fct, $args);
    $this->count = $n[0]['count'];
  }

  function getData () {
    $args = $this->args;
    $p = isset ($_GET['p']) ? $_GET['p'] : 1;
    $col = isset ($_GET['col']) ? $_GET['col'] : $this->defaultColOrder;
    $order = (isset ($_GET['sort']) && $_GET['sort'] == 'desc') ? 'DESC' : 'ASC';
    $args[] = $this->base->limit ($this->lines, ($p-1)*$this->lines);
    $args[] = $this->base->order ($this->columns[$col][1], $order);
    $this->data = $this->base->__call ($this->fct, $args);    
  }

  function displayHeader () {
    echo '<tr>';
    $i = 1;
    foreach ($this->columns as $part) {
      $label = $part[0];
      $code = $part[1];
      if ($code !== null)
	echo '<th><a href="'.$this->link_sort ($i).'">'.$label.'</a>';
      else
	echo '<th>'.$label;
      
      if (isset ($_GET['col']) && $_GET['col'] == $i) {
	if ($_GET['sort'] == 'asc')
	  echo ' <img src="'.$this->imagesPath.'/Asc.gif"></img>';
	else
	  echo ' <img src="'.$this->imagesPath.'/Desc.gif"></img>';
      }
      echo '</th>';
      $i++;
    }
    echo '</tr>';    
  }

  function displayPagination () {
    if ($this->count === null)
      $this->getCount ();
    $npages = ceil($this->count / $this->lines);
    if ($npages < 1)
      $npages = 1;
    $p = isset ($_GET['p']) ? $_GET['p'] : '1';
    echo '<div class="navigdiv">';
    if ($p == 1) {
      echo '<img src="'.$this->imagesPath.'/FirstOff.gif"></img> ';
      echo '<img src="'.$this->imagesPath.'/PrevOff.gif"></img> ';
    } else {
      echo '<a href="'.$this->link_page (1).'"><img src="'.$this->imagesPath.'/First.gif"></img></a> ';
      echo '<a href="'.$this->link_page ($p-1).'"><img src="'.$this->imagesPath.'/Prev.gif"></img></a> ';
    }
    echo '<span class="navign">'.$p." de ".$npages."</span>";
    if ($p == $npages) {
      echo ' <img src="'.$this->imagesPath.'/NextOff.gif"></img>';
      echo ' <img src="'.$this->imagesPath.'/LastOff.gif"></img>';
    } else {
      echo ' <a href="'.$this->link_page ($p+1).'"><img src="'.$this->imagesPath.'/Next.gif"></img></a>';
      echo ' <a href="'.$this->link_page ($npages).'"><img src="'.$this->imagesPath.'/Last.gif"></img></a>';
    }
    echo '</div>';    
  }
  
  function displayData ($cols) {
    if ($this->data === null)
      $this->getData();
    if (count ($this->data)) {
      $impair = true;
      foreach ($this->data as $dat) {
	echo '<tr class="'.($impair ? 'impair' : 'pair').'">';
	$i = 1;
	foreach ($cols as $col) {
	  echo '<td>';
	  if ($this->columns[$i][2] !== null) {
	    echo '<a href="'.$this->add_url_params (call_user_func ($this->columns[$i][2], $dat[$this->columns[$i][3]])).'">';
	  }
	  echo $dat[$col];
	  if ($this->columns[$i][2] !== null) {
	    echo '</a>';
	  }
	  echo '</td>';
	  $i++;
	}
	echo '</tr>';
	$impair = !$impair;
      }
    }
  }

  function link_sort ($col) {
    if (isset ($_GET['col']) && $_GET['col'] == $col && isset ($_GET['sort']) && $_GET['sort'] == 'asc')
      $sort = 'desc';
    else
      $sort = 'asc';
    return $this->url_file.'?'.http_build_query (array_merge ($this->url_args,
							      array ('col' => $col,
								     'sort' => $sort
								     )));
  }

  function link_page ($p) {
    return $this->url_file.'?'.http_build_query (array_merge ($this->url_args,
							      array ('col' => $_GET['col'],
								     'sort' => $_GET['sort'],
								     'p' => $p
								     )));
  }

  function add_url_params ($arr) {
    return $arr[0].'?'.http_build_query (array_merge ($arr[1],
						      array ('col' => $_GET['col'],
							     'sort' => $_GET['sort'],
							     'p' => $_GET['p']
							     )));    
  }
}
?>
