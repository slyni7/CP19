--½ºÄù¾î ¾Ïµå µå·¡°ï
local m=18452988
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","H")
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DESTROY)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_WIND,ATTRIBUTE_WATER,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.nfil21(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_LINK)
end
function cm.nfun21(g)
	if not g:IsExists(cm.nfil22,1,nil,ATTRIBUTE_FIRE) then
		return false
	end
	if not g:IsExists(cm.nfil22,1,nil,ATTRIBUTE_EARTH) then
		return false
	end
	if not g:IsExists(cm.nfil22,1,nil,ATTRIBUTE_LIGHT) then
		return false
	end
	if not g:IsExists(cm.nfil22,1,nil,ATTRIBUTE_WIND) then
		return false
	end
	if not g:IsExists(cm.nfil22,1,nil,ATTRIBUTE_WATER) then
		return false
	end
	if not g:IsExists(cm.nfil22,1,nil,ATTRIBUTE_DARK) then
		return false
	end
	return true
end
function cm.nfil22(c,att)
	return c:IsAttribute(att) or c:IsHasSquareMana(att)
end
function cm.nfun22(g,st,mt)
	return aux.SquareCheck(g,st,mt,false)
end
function cm.con2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GMGroup(cm.nfil21,tp,"G",0,nil)
	local st=c:GetSquareMana()
	local mt={}
	if not cm.nfun21(g) then
		return false
	end
	local res=false
	local ct=math.max(6,#g)
	for i=1,ct do
		res=g:CheckSubGroup(cm.nfun22,i,i,st,mt)
		if res then
			break
		end
	end
	return Duel.GetLocCount(tp,"M")>0 and res
end
function cm.cfil3(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function cm.cfun3(g,st,mt)
	return aux.SquareCheck(g,st,mt,true)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.cfil3,tp,"G",0,nil)
	local st={ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_WIND,ATTRIBUTE_WATER,ATTRIBUTE_DARK}
	local mt={}
	if chk==0 then
		if not cm.nfun21(g) then
			return false
		end
		local res=false
		for i=1,3 do
			res=g:CheckSubGroup(cm.cfun3,i,i,st,mt)
			if res then
				break
			end
		end
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,cm.cfun3,false,1,3,st,mt)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,"O","O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,"O","O",1,1,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end