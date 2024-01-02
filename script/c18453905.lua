--더블 클릭!
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
s.listed_names={18453902}
function s.tfil11(c,e)
	return c:IsCanBeEffectTarget(e)
end
function s.tfun12(sg,res)
	return #sg==2 or res
end
function s.tfil13(c)
	return c:IsCode(18453902) and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and chkc~=c
	end
	local g=Duel.GMGroup(s.tfil11,tp,"O","O",c,e)
	local sg=Duel.GMGroup(s.tfil13,tp,"DG",0,nil)
	if chk==0 then
		return g:CheckSubGroup(s.tfun12,1,2,#sg>0)
	end
	local tg=g:SelectSubGroup(tp,s.tfun12,false,1,2,#sg>0)
	e:SetLabel(#tg)
	Duel.SetTargetCard(tg)
	if #tg==1 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DG")
	else
		e:SetCategory(0)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,s.tfil13,tp,"DG",0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end